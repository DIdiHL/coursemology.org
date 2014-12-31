class CoursePurchasesController < ApplicationController
  load_and_authorize_resource
  load_resource :publish_record

  def new
    @course_purchase.user = current_user
    @course_purchase.publish_record = @publish_record
    @course_purchase.save

    # If the user wants to directly top up the capacity after purchasing a course he will be
    # directed to the transaction page. The course will be duplicated for the buyer only if
    # the capacity is above zero.
    if params[:vacancy] && params[:vacancy].to_f > 0
      perform_transaction
    else
      redirect_to need_payment_publish_record_course_purchase_path(@publish_record, @course_purchase)
    end
  end

  def perform_transaction
    redirect_to new_course_purchase_purchase_record_path(
                    @course_purchase, {vacancy: params[:vacancy]})
  end

  def select_course_start_date
    if @course_purchase.capacity == 0
      redirect_to need_payment_publish_record_course_purchase_path(@publish_record, @course_purchase)
    elsif @course_purchase.course
      redirect_to course_path(@course_purchase.course)
    end
  end

  def duplicate_course
    if @course_purchase.course
      redirect_to course_path(@course_purchase)
    end
    authorize! :create, Course

    course = @publish_record.course
    from_date = course.start_at
    require 'duplication'
    begin
      course_diff = Time.parse(params[:to_date]) -  Time.parse(from_date)
    rescue
      course_diff =  0
    end

    mission_diff =  course_diff
    training_diff = course_diff

    options = {
        course_diff: course_diff,
        mission_diff: mission_diff,
        training_diff: training_diff,
        mission_files: true,
        training_files: true,
        workbin_files: true
    }
    #
    Course.skip_callback(:create, :after, :initialize_default_settings)
    Assessment.skip_callback(:save, :after, :update_opening_tasks)
    Assessment.skip_callback(:save, :after, :update_closing_tasks)
    Assessment.skip_callback(:save, :after, :create_or_destroy_tasks)
    clone = course.amoeba_dup
    clone.creator = current_user
    user_course = clone.user_courses.build
    user_course.user = current_user
    user_course.role = Role.find_by_name(:lecturer)
    clone.start_at = clone.start_at ? clone.start_at + options[:course_diff] : clone.start_at
    clone.end_at =  clone.end_at ? clone.end_at + options[:course_diff] : clone.end_at

    clone.save
    handle_relationships(clone)
    Course.set_callback(:create, :after, :initialize_default_settings)
    Assessment.set_callback(:save, :after, :update_opening_tasks)
    Assessment.set_callback(:save, :after, :update_closing_tasks)
    Assessment.set_callback(:save, :after, :create_or_destroy_tasks)

    clone.is_original_course = false
    clone.duplication_origin_id = course.id
    @course_purchase.course = clone

    respond_to do |format|
      flash[:notice] = "The course '#{course.title}' has been duplicated."
      format.html { redirect_to course_preferences_path(clone) }

      format.json {render json: {url: course_preferences_path(clone)} }
    end
  end

  def handle_relationships(clone)
    #handle relation tables
    #tab
    t_map = {}
    clone.tabs.each do |tab|
      t_map[tab.id] = tab.duplicate_logs_dest.order("created_at desc").first.origin_obj_id
    end
    t_map.each do |k, v|
      sql = "UPDATE assessments SET tab_id = #{k} WHERE course_id =#{clone.id} AND tab_id = #{v}"
      ActiveRecord::Base.connection.execute(sql)
    end

    #subfolders
    clone.root_folder.subfolders.each do |f|
      f.course = clone
      f.save
    end

    #achievements requirements
    asm_req_logs = clone.assessments.map { |asm| asm.as_asm_reqs.all_dest_logs}.flatten
    asm_logs = clone.assessments.all_dest_logs
    lvl_logs = clone.levels.all_dest_logs
    ach_logs = clone.achievements.all_dest_logs
    logs = asm_req_logs + lvl_logs + ach_logs

    clone.achievements.each do |ach|
      ach.requirements.each do |ar|
        l = (ar.req.duplicate_logs_orig & logs).first
        unless l
          next
        end
        ar.req = l.dest_obj
        ar.save
      end
    end

    #assessment dependency
    clone.assessments.each do |asm|
      if asm.dependent_on.count == 0
        next
      end
      c = []
      asm.dependent_on.each do |dep_asm|
        l = (dep_asm.duplicate_logs_orig & asm_logs).first
        if l
          c << clone.assessments.find(l.dest_obj_id)
        end
      end
      asm.dependent_on = c
      asm.save
    end


    #question position & dependency
    clone.assessments.each do |asm|
      handle_dup_questions_position(asm)
      handle_question_relationship(asm)
    end

    #tags
    clone.tag_groups.each do |tg|
      tg.tags.each do |t|
        t.course = tg.course
        t.save
      end
    end
    q_logs = clone.questions.all_dest_logs
    clone.taggings.each do |tt|
      l = (tt.taggable.duplicate_logs_orig & q_logs).first
      unless l
        next
      end
      tt.taggable = l.dest_obj
      tt.save
    end
  end

  def handle_dup_questions_position(dup)
    pos = 0
    dup.questions.each do |qn|
      dqa = qn.question_assessments.where(assessment_id: dup.id).first
      dqa.position = pos
      dqa.save
      pos += 1
    end
  end

  def handle_question_relationship(assessment)
    qns_logs = assessment.questions.all_dest_logs
    question_above = Array.new
    assessment.questions.each do |qn|
      unless qn.dependent_on
        next
      end
      l = (qn.dependent_on.duplicate_logs_orig & qns_logs).first
      unless l
        next
      end

      if question_above.include?(l.dest_obj_id)
        qn.dependent_id = l.dest_obj_id
      else
        qn.dependent_id = nil
      end
      qn.save
      question_above << qn.id
    end
  end

end
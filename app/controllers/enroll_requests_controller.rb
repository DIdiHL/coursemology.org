class EnrollRequestsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :enroll_request, through: :course

  before_filter :load_general_course_data, only: [:index, :new]

  def index
    # only staff should be able to access this page
    # here staff can approve student to enroll to a class
    @staff_requests = []
    @student_requests = []

    std_role = Role.find_by_name("student")
    @enroll_requests.each do |er|
      if er.role == std_role
        @student_requests << er
      else
        @staff_requests << er
      end
    end

    respond_to do |format|
      format.html
      format.json {
        staff_request_hashes = get_request_hash(@staff_requests)
        student_request_hashes = get_request_hash(@student_requests)
        response_hash = {staff_requests: staff_request_hashes, student_requests: student_request_hashes}
        add_course_info_to_response_hash(response_hash)
        render json: response_hash
      }
    end
  end

  def get_request_hash(requests)
    result = []
    requests.each do |request|
      request_hash = request.as_json(include: {user: {only: [:name, :email]}, role: {only: :title}})
      request_hash[:path] = course_enroll_request_path(@course, request.id, 'json')
      result << request_hash
    end
    result
  end

  def add_course_info_to_response_hash(response_hash)
    if @course.course_purchase
      response_hash[:enrolledStudentCount] = @course.student_courses.count
      response_hash[:courseCapacity] = @course.course_purchase.capacity
      response_hash[:availableSeatCount] = @course.course_purchase.vacancy
    end
  end

  def new
    unless current_user
      redirect_to new_user_session_path
      return
    end
    unless @course.is_open?
      redirect_to course_path(@course)
      return
    end

    @er = EnrollRequest.find_by_user_id_and_course_id(current_user.id, @course.id)
    if !curr_user_course.id && !@er
      if params[:role]
        @role = Role.find_by_name(params[:role])
      else
        @role = Role.find_by_name('student')
      end
      if @role == Role.shared.first
        authorize! :ask_for_share, Course
      end
      @enroll_request.course = @course
      @enroll_request.user = current_user
      @enroll_request.role = @role
      @enroll_request.save
      @enroll_request.notify_lecturer(course_enroll_requests_url(@course))
      @er = @enroll_request
    end
  end

  def approve_request(enroll_request)
    authorize! :approve, EnrollRequest
    @course.enrol_user(enroll_request.user, enroll_request.role)
  end

  def approve_request!(enroll_request)
    authorize! :approve, EnrollRequest
    @course.enrol_user!(enroll_request.user, enroll_request.role)
  end

  def destroy_selected
    enroll_requests = EnrollRequest.where(id: params[:ids])
    has_error = false
    message = nil
    deleted_ids = []
    begin
      deleted_count = 0
      enroll_requests.each do |enroll_request|
        if params[:approved] == 'true'
          approve_request!(enroll_request)
        end

        deleted_ids << enroll_request.id
        enroll_request.destroy
        deleted_count += 1
      end

      if params[:approved] == 'true'
        message = t('course.enrolment.approved_selected_message_with_count') % deleted_count
      else
        message = t('course.enrolment.deleted_selected_message_with_count') % deleted_count
      end
    rescue
      has_error = true
      message = t('course.enrolment.failed_to_enrol_format') % $!.message
    end

    respond_to do |format|
      format.json do
        response_hash = {message: message, approved_ids: deleted_ids}
        add_course_info_to_response_hash(response_hash)
        if has_error
          render json: response_hash, status: :internal_server_error
        else
          render json: response_hash, status: :ok
        end
      end
    end
  end

  def destroy
    has_error = false
    message = nil
    email = @enroll_request.user.email

    begin
      if params[:approved] == 'true'
        # create new UserCourse record
        approve_request!(@enroll_request)
        message = t('course.enrolment.approved_message_format') % email
      end

      @enroll_request.destroy
      if !message
        message = t('course.enrolment.deleted_message_format') % email
      end
    rescue
      has_error = true
      message = $!.message
    end

    respond_to do |format|
      format.json do
        response_hash = {message: message}
        add_course_info_to_response_hash(response_hash)
        if has_error
          # Assuming the only error that can happen is no vacancy error
          render json: response_hash, status: :internal_server_error
        else
          render json: response_hash, status: :ok
        end
      end
    end
  end
end

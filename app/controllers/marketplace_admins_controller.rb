class MarketplaceAdminsController < ApplicationController
  before_filter :authorize_admin
  before_filter :verify_params

  def payout_panel
  end

  def courses
    if @successful
      @courses = Course.find_all_by_creator_id(@user)
      @result['courses'] = []
      @courses.each { |course|
        @result['courses'] << {
            course_id: course.id,
            course_title: course.title
        }
      }
    end

    respond_to do |format|
      if @successful
        format.json {render json: @result, status: :ok}
      else
        format.json {render json: @result, status: :bad_request}
      end
    end
  end

  def payout_records
    verify_course_params

    if @successful
      @result['course_purchases'] = []
      if @course.publish_record
        @course.publish_record.course_purchases.each { |course_purchase|
          course_purchase_hash = course_purchase.as_json
          course_purchase_hash['user'] = {
              'name' => course_purchase.user.name,
              'email' => course_purchase.user.email
          }
          course_purchase_hash['all_purchases_amount'] = course_purchase.all_purchases_amount
          course_purchase_hash['unclaimed_purchases_amount'] = course_purchase.unclaimed_purchases_amount
          course_purchase_hash['purchase_records'] = course_purchase.purchase_records.as_json
          course_purchase_hash['capacity'] = course_purchase.capacity
          course_purchase_hash['payout_path'] =
              claim_payouts_publish_record_path(@course.publish_record, course_purchase_id: course_purchase.id)
          if course_purchase.course
            course_purchase_hash['number_of_students'] = course_purchase.course.student_courses.count
          else
            course_purchase_hash['number_of_students'] = 0
          end

          @result['course_purchases'] << course_purchase_hash
        }
        @result['status'] = 'success'
        @result['message'] = t('Marketplace.admin.payout_records_fetched_notice')
      end
    end

    respond_to do |format|
      if @successful
        format.json {render json: @result, status: :ok}
      else
        format.json {render json: @result, status: :bad_request}
      end
    end
  end

  private
  def authorize_admin
    authorize!(:manage, :user)
  end

  def verify_params
    @successful = true
    @result = {}
    if !params[:email] or params[:email] == ''
      @result['status'] = 'error'
      @result['message'] = t('Marketplace.admin.user_not_specified_error_msg')
      @successful = false
    else
      @user = User.find_by_email(params[:email])
      if !@user
        @result['status'] = 'error'
        @result['message'] = t('Marketplace.admin.user_not_found_error_msg')
        @successful = false
      end
    end
  end

  def verify_course_params
    if !params[:course_id]
      @result['message'] = t('Marketplace.admin.course_id_not_specified_error_msg')
      @successful = false
    end
    @course = Course.find(params[:course_id])
    if !@course
      @result['message'] = t('Marketplace.admin.course_not_found_error_msg')
      @successful = false
    elsif @course.creator_id != @user.id
      @result['message'] = t('Marketplace.admin.course_creator_not_match_error_msg')
      @successful = false
    end
  end
end
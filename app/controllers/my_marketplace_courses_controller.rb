class MyMarketplaceCoursesController < ApplicationController

  def index
    @created_courses = get_created_courses
    @purchased_courses = get_purchased_courses
  end

  def show_created
    @course = Course.find(params[:my_marketplace_course_id])
    if not can? :manage, @course
      redirect_to access_denied_path,
                  alert: t('Marketplace.my_marketplace_courses.manage_publication_setting_access_denied')
    end
  end

  def show_purchased
  end

  def edit_created
  end

  def edit_purchased
  end

  def published_markets
    respond_to_ajax_action
  end

  def purchase_history
    respond_to_ajax_action
  end

  #----------------------controller helpers---------------------
  def get_created_courses
    result = []
    current_user.courses.each { |course|
      if course.is_original_course? && course.creator_id == current_user.id
        result << course
      end
    }
    result
  end

  def get_purchased_courses
    result = []
    current_user.course_purchases.each { |purchase|
      result << purchase.duplicate_course
    }
    result
  end

  def respond_to_ajax_action
    @course = Course.find(params[:my_marketplace_course_id])
    respond_to do |format|
      format.js
    end
  end

end

module CoursesHelper
  def filter_params
    result = @show_creators.to_query('show_creators')
    if params[:free]
      result.concat('&' + true.to_query('free'))
    end

    if params[:paid]
      result.concat('&' + true.to_query('paid'))
    end
    result
  end

  def should_show_purchase_options?
    params[:ref] == 'marketplace' &&
        current_user && current_user.system_role_id < 4 &&
        @course.is_published_in_marketplace?
  end

  def get_course_purchase
    CoursePurchase.find_by_publish_record_id_and_user_id(@course.publish_record, current_user)
  end
end

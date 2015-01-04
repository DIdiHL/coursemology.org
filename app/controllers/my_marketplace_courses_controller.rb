class MyMarketplaceCoursesController < ApplicationController

  def index
    @created_courses = get_created_courses
    @course_purchases = get_course_purchases
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

  def get_course_purchases
    result = []
    current_user.course_purchases.each { |purchase|
      result << purchase
    }
    result
  end

end

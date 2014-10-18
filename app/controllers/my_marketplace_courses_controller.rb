class MyMarketplaceCoursesController < ApplicationController
  def index
    @created_courses = get_created_courses
    @purchased_courses = get_purchased_courses

  end

  def show_created
  end

  def show_purchased
  end

  def edit_created
  end

  def edit_purchased
  end

  #----------------------controller helpers---------------------
  def get_created_courses
    result = []
    current_user.courses.each { |course|
      if course.is_original_course?
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
end

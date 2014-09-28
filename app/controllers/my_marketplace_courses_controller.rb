class MyMarketplaceCoursesController < ApplicationController
  def index
    created_courses = get_created_courses
    purchased_courses = get_purchased_courses

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
    # TODO implement
  end

  def get_purchased_courses
    # TODO implement
  end
end

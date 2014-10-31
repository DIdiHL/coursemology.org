class AddIsOriginalCourseToCourses < ActiveRecord::Migration
  def up
    add_column :courses, :is_original_course, :boolean, default: true
  end

  def down
    remove_column :courses, :is_original_course
  end
end

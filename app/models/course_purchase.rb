class CoursePurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :original_course, :class_name => 'Course', :foreign_key => 'original_course_id'
  belongs_to :duplicate_course, :class_name => 'Course', :foreign_key => 'duplicate_course_id'
end

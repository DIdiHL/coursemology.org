class CoursePurchase < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CoursePurchaseValidator

  attr_accessible :user, :original_course, :duplicate_course

  belongs_to :user
  belongs_to :original_course, :class_name => 'Course', :foreign_key => 'course_id'
  has_one :duplicate_course, :class_name => 'Course', :foreign_key => 'course_purchase_id', :dependent => :delete
end

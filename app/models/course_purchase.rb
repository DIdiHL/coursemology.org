class CoursePurchase < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CoursePurchaseValidator
  validates_uniqueness_of :publish_record_id, scope: :user_id

  belongs_to :user
  belongs_to :publish_record

  has_one :course

  def course=(course)
    if not self.id
      raise 'Course purchase not saved yet. Unable to create association'
    end

    if course.is_original_course?
      raise "An originally created course can't be the duplicate course."
    end

    if course
      course.update_attributes(course_purchase_id: self.id)
    end
  end

end

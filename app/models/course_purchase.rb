class CoursePurchase < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CoursePurchaseValidator
  validates_uniqueness_of :publish_record_id, scope: :user_id

  belongs_to :user
  belongs_to :publish_record

  has_one :course
  has_many :purchase_records

  def capacity
    self.purchase_records.map{ |purchase_record| purchase_record.seat_count }.sum
  end

  def vacancy
    self.purchase_records.map{ |purchase_record| purchase_record.vacancy }.sum
  end

  def purchase_records_with_vacancy
    self.purchase_records.select { |purchase_record| purchase_record.has_vacancy? }
  end

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

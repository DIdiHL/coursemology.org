class PublishRecord < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with PublishRecordValidator
  validates_uniqueness_of :course_id
  validates :price_per_seat, numericality: {greater_than_or_equal_to: 0}
  validates :published, inclusion: {in: [true, false]}

  attr_accessible :price_per_seat, :published, :course_id

  belongs_to :course
  has_many :course_purchases

  def free?
    self.price_per_seat == 0
  end
end

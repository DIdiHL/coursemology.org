class PublishRecord < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with PublishRecordValidator
  validates_uniqueness_of :course_id

  belongs_to :course

  has_many :course_purchases
end

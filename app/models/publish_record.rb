class PublishRecord < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with PublishRecordValidator
  validates_uniqueness_of :course_id, :scope => :marketplace_id

  belongs_to :course
  belongs_to :marketplace
end

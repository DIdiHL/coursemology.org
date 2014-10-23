class PublishRecord < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with PublishRecordValidator

  belongs_to :course
  belongs_to :marketplace
end

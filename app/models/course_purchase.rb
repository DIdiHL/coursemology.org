class CoursePurchase < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CoursePurchaseValidator

  belongs_to :user
  belongs_to :publish_record
  has_one :course
end

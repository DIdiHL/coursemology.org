class CoursePurchase < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CoursePurchaseValidator
  validates_uniqueness_of :publish_record_id, scope: :user_id

  belongs_to :user
  belongs_to :publish_record
  has_one :course
end

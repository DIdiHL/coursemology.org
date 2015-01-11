class PayoutIdentity < ActiveRecord::Base
  validates_uniqueness_of :user_id
  attr_accessible :receiver_id, :receiver_type, :user_id
  belongs_to :user
end

class PayoutTransaction < ActiveRecord::Base
  attr_accessible :payout_id, :payout_processor

  belongs_to :purchase_record
end

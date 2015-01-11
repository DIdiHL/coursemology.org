class PayoutTransaction < ActiveRecord::Base
  attr_accessible :payout_id, :payout_processor

  @@PROCESSOR_PAYPAL = 'paypal'

  belongs_to :purchase_record

  def self.PROCESSOR_PAYPAL
    @@PROCESSOR_PAYPAL
  end

  def is_paid?
    !!self.payout_id
  end
end

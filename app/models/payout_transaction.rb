class PayoutTransaction < ActiveRecord::Base
  attr_accessible :payout_id, :payout_processor, :payout_batch_id, :payout_status

  @@PROCESSOR_PAYPAL = 'paypal'

  belongs_to :purchase_record

  def self.PROCESSOR_PAYPAL
    @@PROCESSOR_PAYPAL
  end

  def is_paid?
    # For now, only consider PayPal. Add more conditions
    # when other payment processors are added
    self.payout_status == 'SUCCESS'
  end

  def is_processing?
    self.payout_status == 'PROCESSING' or
        (!self.payout_id && self.payout_batch_id)
  end
end

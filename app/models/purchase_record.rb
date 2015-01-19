class PurchaseRecord < ActiveRecord::Base
  # price_per_seat takes a snapshot of the price of the course at
  # the time of purchase so that, later when price changes, this
  # price stays unchanged.
  validates :seat_count, numericality: {greater_than_or_equal_to: 0}

  attr_accessible :seat_count, :price_per_seat, :course_purchase, :is_paid?

  belongs_to :course_purchase
  has_one :payment_transaction
  has_one :payout_transaction

  def payment_required?
    self.price_per_seat > 0 and !self.is_paid?
  end

  def payout_amount
    self.seat_count * self.price_per_seat * I18n.t('number.payout_proportion').to_f
  end

  def execute_payout
    payout_identity = self.course_purchase.publish_record.course.creator.payout_identity
    if payout_identity
      if payout_identity.receiver_type == 'paypal'
        execute_paypal_payout(payout_identity)
      end
    end
  end

  def execute_paypal_payout(payout_identity)
    require 'paypal_helper'
    PayPalHelper.execute_single_paypal_payout(self, payout_identity)
  end

  def is_payout_done?
    self.payout_transaction and self.payout_transaction.is_paid?
  end

  def has_pending_payout?
    !self.payout_transaction
  end

  def is_processing_payout?
    self.payout_transaction and self.payout_transaction.is_processing?
  end
end

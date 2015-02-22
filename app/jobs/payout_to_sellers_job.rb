class PayoutToSellersJob < Struct.new(:course_id, :name, :item_type, :item_id)
  def perform
    require 'modules/paypal_helper'

    CoursePurchase.all.each do |course_purchase|
      PayPalHelper.execute_batch_paypal_payout_for_course_purchase(course_purchase)
    end
  end
end

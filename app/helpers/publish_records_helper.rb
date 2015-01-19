module PublishRecordsHelper
  def get_payout_identity
    result = current_user.payout_identity
    result ||= PayoutIdentity.new
  end

  def refresh_payout_status(course_purchase)
    require 'paypal_helper'
    PayPalHelper.confirm_course_purchase_payout(course_purchase)
  end
end

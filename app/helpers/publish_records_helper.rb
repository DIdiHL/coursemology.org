module PublishRecordsHelper
  def get_payout_identity
    result = current_user.payout_identity
    result ||= PayoutIdentity.new
  end

  def refresh_payout_status(course_purchase)
    require 'paypal_helper'
    PayPalHelper.confirm_course_purchase_payout(course_purchase)
  end

  def get_purchase_records(course_purchase, start_time, end_time)
    course_purchase.purchase_records.where('created_at between ? and ?', start_time, end_time)
  end

  def get_invoice_time
    (DateTime.now - 1.month).to_formatted_s(:month_and_year)
  end

  def invoice_format_date(date)
    date.strftime(t('Marketplace.mailer.invoice.date_format'))
  end

  def beginning_of_last_month
    (Time.now - 1.month).at_beginning_of_month
  end

  def end_of_last_month
    (Time.now - 1.month).end_of_month
  end
end

module PurchaseRecordsHelper
  def get_confirmation_title
    if !@purchase_record.is_paid?
      return t('Marketplace.transaction.payment_confirmation.failure_title')
    elsif @has_pending_payment
      return t('Marketplace.transaction.payment_confirmation.success_title')
    else
      return t('Marketplace.transaction.payment_confirmation.already_paid_title')
    end
  end

  def get_confirmation_notice
    if !@purchase_record.is_paid?
      return t('Marketplace.transaction.payment_confirmation.failure_notice')
    elsif @has_pending_payment
      return t('Marketplace.transaction.payment_confirmation.success_notice_format') %
          @purchase_record.seat_count.to_s
    else
      return t('Marketplace.transaction.payment_confirmation.already_paid_notice')
    end
  end

  def get_btn_url
    if !@purchase_record.is_paid?
      return pay_course_purchase_purchase_record_path(@course_purchase, @purchase_record)
    elsif @has_pending_payment
      if @course_purchase.course
        return course_path(@course_purchase.course)
      else
        return select_course_start_date_publish_record_course_purchase_path(@course_purchase.publish_record, @course_purchase)
      end
    else
      # TODO direct to the buyer's course's settings page after it is implemented
      return course_path(@course_purchase.publish_record.course, ref: 'marketplace')
    end
  end

  def get_btn_text
    if !@purchase_record.is_paid?
      return t('Marketplace.transaction.payment_confirmation.make_payment_btn_text')
    elsif @has_pending_payment
      return t('Marketplace.transaction.payment_confirmation.go_to_course_btn_text')
    else
      return t('Marketplace.transaction.payment_confirmation.go_to_master_course_btn_text')
    end
  end
end
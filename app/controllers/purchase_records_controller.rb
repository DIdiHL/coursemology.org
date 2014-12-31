class PurchaseRecordsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :course_purchase

  def new
    @purchase_record.course_purchase = @course_purchase
    @purchase_record.seat_count = params[:vacancy]
    @purchase_record.price_per_seat = @course_purchase.publish_record.price_per_seat
    @purchase_record.save
    redirect_to pay_course_purchase_purchase_record_path(@course_purchase, @purchase_record)
  end

  def pay
    # TODO direct to payment processor
  end

  def confirm
    @has_pending_payment = !@purchase_record.is_paid?
    authorize! :new, @purchase_record

    @purchase_record.is_paid = is_payment_successful?
    @purchase_record.save
  end

  def is_payment_successful?
    # TODO implement checking logic
    true
  end

  def destroy
    if @purchase_record.is_paid?
      flash[:error] = t('Marketplace.course_marketplace_preference.cancel_paid_purchase_record_error')
    else
      begin
        @purchase_record.delete
        flash[:notice] = t('Marketplace.course_marketplace_preference.order_canceled_flash')
      rescue
        flash[:error] = t('Marketplace.course_marketplace_preference.cancel_paid_purchase_record_error')
      end
    end
    redirect_to course_preferences_path(@course_purchase.course, _tab: 'purchase'), flash: flash
  end
end
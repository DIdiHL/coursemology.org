class PurchaseRecordsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :course_purchase

  require 'paypal-sdk-rest'
  include PayPal::SDK::REST

  def new
    if params[:vacancy] && params[:vacancy].to_f < 0
      redirect_to course_path(@course_purchase.publish_record.course, ref: 'marketplace'),
                  flash: {error: t('Marketplace.transaction.negative_vacancy_error')}
    else
      @purchase_record.course_purchase = @course_purchase
      @purchase_record.seat_count = params[:vacancy]
      @purchase_record.price_per_seat = @course_purchase.publish_record.price_per_seat
      @purchase_record.save
      if @purchase_record.payment_required?
        redirect_to select_payment_method_course_purchase_purchase_record_path(@course_purchase, @purchase_record)
      else
        @purchase_record.is_paid = true
        redirect_to confirm_course_purchase_purchase_record_path(@course_purchase, @purchase_record)
      end
    end
  end

  def pay
    if params[:payment_method] == 'paypal'
      pay_with_paypal
    end
  end

  def pay_with_paypal
    @payment = PayPal::SDK::REST::Payment.new({
        :intent => "sale",
        :payer => {
            :payment_method => "paypal" },
        :redirect_urls => {
            :return_url => "http://0.0.0.0:3000" +
                paypal_confirm_course_purchase_purchase_record_path(@course_purchase, @purchase_record) +
                "?success=true",
            :cancel_url => "http://0.0.0.0:3000" +
                paypal_confirm_course_purchase_purchase_record_path(@course_purchase, @purchase_record) +
                "?cancel=true" },
        :transactions => [ {
            :amount => {
                :total => "%d" % (@purchase_record.price_per_seat * @purchase_record.seat_count),
                :currency => "SGD" },
            :description => t('Marketplace.transaction.payment_method.paypal_description_format') %
                [@purchase_record.seat_count,
                 @course_purchase.publish_record.course.title,
                 view_context.number_to_currency(@purchase_record.price_per_seat)] } ] } )

    if @payment.create
      redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
      redirect_to redirect_url
    else
      redirect_to select_payment_method_course_purchase_purchase_record_path(@course_purchase, @purchase_record),
                  flash: {error: t('Marketplace.transaction.payment_method.paypal_error')}
    end

  end

  def paypal_confirm
    confirm_payment('PayPal')
  end

  def confirm_payment(payment_processor)
    if params[:cancel] and params[:cancel] == 'true'
      redirect_to_course({error: t('Marketplace.transaction.cancelled_error')})
    elsif params[:success] and params[:success] == 'true' and params[:paymentId] and params[:PayerID]
      @payment = Payment.find(params[:paymentId])
      if @payment.execute(payer_id: params[:PayerID])
        payment_transaction = PaymentTransaction.new(
            payment_id: params[:paymentId],
            payment_processor: payment_processor)
        payment_transaction.purchase_record = @purchase_record
        payment_transaction.save

        @purchase_record.execute_payout

        @purchase_record.is_paid = true
        @purchase_record.save
        redirect_to confirm_course_purchase_purchase_record_path(@course_purchase, @purchase_record)
      else
        redirect_to_course({error: @payment.error.message})
      end
    else
      redirect_to_course({error: t('Marketplace.transaction.payment_method.paypal_missing_parameter_error')})
    end
  end

  def redirect_to_course(flash_options = {})
    if @course_purchase.course
      redirect_to course_preferences_path(@course_purchase.course, _tab: 'purchase'), flash: flash_options
    else
      redirect_to course_path(@course_purchase.publish_record.course, ref: 'marketplace'), flash: flash_options
    end
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
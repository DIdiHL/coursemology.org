module PayPalHelper
  def PayPalHelper.get_access_token
    PayPal::SDK::Core::API::REST.new.token
  end

  def PayPalHelper.get_bearer_header
    'Bearer ' + PayPalHelper.get_access_token
  end

  def PayPalHelper.get_paypal_payout_item(purchase_record, payout_identity)
    purchase_record.payout_transaction ||=
        PayoutTransaction.create(payout_processor: PayoutTransaction.PROCESSOR_PAYPAL)
    payout_note = I18n.t('Marketplace.payout_identity.payout_email_note_format') %
        purchase_record.course_purchase.publish_record.course.title
    {
        recipient_type: 'EMAIL',
        amount: {
            value: purchase_record.payout_amount,
            currency: 'SGD'
        },
        receiver: payout_identity.receiver_id,
        note: payout_note,
        sender_item_id: purchase_record.payout_transaction.id
    }
  end

  def PayPalHelper.execute_paypal_payout(payout_items)
    email_subject = I18n.t('Marketplace.payout_identity.payout_email_subject')
    post_options = {
        sender_batch_header: {
            email_subject: email_subject
        },
        items: payout_items.take(500)
    }

    sync_mode = (payout_items.count == 1) ? '?sync_mode=true' : ''
    operation_uri = ENV['paypal_api_base_url'] + '/v1/payments/payouts' + sync_mode
    auth = PayPalHelper.get_bearer_header
    result = HTTParty.post(operation_uri,
                           body: post_options.to_json,
                           headers: {'Content-Type' => 'application/json','Authorization' => auth})
    JSON.parse(result.response.body)
  end

  def PayPalHelper.execute_single_paypal_payout(purchase_record, payout_identity)
    if purchase_record.payout_transaction and purchase_record.payout_transaction.is_paid?
      return []
    end

    payout_item = PayPalHelper.get_paypal_payout_item(purchase_record, payout_identity)
    response = PayPalHelper.execute_paypal_payout([payout_item])
    purchase_record.payout_transaction.payout_id = response['items'][0]['payout_item_id'].to_f
    purchase_record.payout_transaction.payout_status = response['items'][0]['transaction_status']
    purchase_record.payout_transaction.save
  end

  def PayPalHelper.execute_batch_paypal_payout(purchase_records, payout_identity)
    payout_items = purchase_records.map { |purchase_record|
      (purchase_record.payout_transaction and purchase_record.payout_transaction.is_paid?) ?
      nil : PayPalHelper.get_paypal_payout_item(purchase_record, payout_identity)
    }.select { |item| item != nil }

    response = PayPalHelper.execute_paypal_payout(payout_items)
    payout_batch_id = response['batch_header']['payout_batch_id']
    purchase_records.each { |purchase_record|
      purchase_record.payout_transaction.payout_batch_id = payout_batch_id;
      purchase_record.payout_transaction.save!
    }
  end

  def PayPalHelper.confirm_async_paypal_payout(payout_batch_id)
    operation_uri = ENV['paypal_api_base_url'] + '/v1/payments/payouts/' + payout_batch_id
    auth = PayPalHelper.get_bearer_header
    result = HTTParty.get(operation_uri,
                            headers: {'Authorization' => auth})
    response_body = JSON.parse(result.response.body)

    response_body['items'].each { |payout_item|
      payout_transaction = PayoutTransaction.find(payout_item['payout_item']['sender_item_id'])
      payout_transaction.payout_id = payout_item['payout_item_id']
      payout_transaction.payout_status = payout_item['transaction_status']
      payout_transaction.save
    }
  end

  def PayPalHelper.confirm_course_purchase_payout(course_purchase)
    require 'set'
    payout_batch_id_map = {}
    course_purchase.purchase_records.each { |purchase_record|
      if purchase_record.is_processing_payout?
        payout_transaction = purchase_record.payout_transaction
        payout_batch_id = payout_transaction.payout_batch_id
        if payout_batch_id_map.has_key?(payout_batch_id)
          payout_batch_id_map[payout_batch_id].add(payout_transaction.payout_processor)
        else
          payout_batch_id_map[payout_batch_id] = Set.new([payout_transaction.payout_processor])
        end
      end
    }

    payout_batch_id_map.each { |payout_batch_id, payment_processors|
      payment_processors.each { |payment_processor|
        if payment_processor == PayoutTransaction.PROCESSOR_PAYPAL
          PayPalHelper.confirm_async_paypal_payout(payout_batch_id)
        end
      }
    }
  end
end
class PaymentTransaction < ActiveRecord::Base
  attr_accessible :payment_id, :payment_processor

  belongs_to :purchase_record
end

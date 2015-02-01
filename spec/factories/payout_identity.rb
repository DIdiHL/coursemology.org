FactoryGirl.define do
  factory :payout_identity do
    receiver_id 'abcdefg'
    receiver_type 'paypal'
  end
end
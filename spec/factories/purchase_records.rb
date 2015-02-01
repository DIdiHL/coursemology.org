# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase_record do
    seat_count 5

    after(:create) do |purchase_record, evaluator|
      if evaluator.course_purchase
        purchase_record.course_purchase = evaluator.course_purchase
        evaluator.course_purchase.reload
      end
    end
  end
end

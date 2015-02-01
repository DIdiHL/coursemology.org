# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :publish_record do
    published true

    after(:create) do |publish_record, evaluator|
      if evaluator.course
        publish_record.course = evaluator.course
        publish_record.save
        evaluator.course.reload
      end
    end
  end
end

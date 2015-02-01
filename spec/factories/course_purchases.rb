FactoryGirl.define do
  factory :course_purchase do
    after(:create) do |course_purchase, evaluator|
      if evaluator.course
        course_purchase.course = evaluator.course
        evaluator.course.reload
      end

      if evaluator.publish_record
        course_purchase.publish_record = evaluator.publish_record
        course_purchase.save
        evaluator.publish_record.reload
      end
    end
  end
end

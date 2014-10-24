require 'rails_helper'
describe 'CoursePurchases' do
  let(:test_marketplace) { FactoryGirl.create(:marketplace) }
  let(:original_course1) { FactoryGirl.create(:course) }
  let(:original_course2) { FactoryGirl.create(:course) }

  let(:original_course1_publish_record) { FactoryGirl.create(
        :publish_record,
        course: original_course1,
        marketplace: test_marketplace
  ) }

  let(:original_course2_publish_record) { FactoryGirl.create(
      :publish_record,
      course: original_course2,
      marketplace: test_marketplace
  ) }

  let(:duplicate_course1) { FactoryGirl.create(:course) }
  let(:duplicate_course2) { FactoryGirl.create(:course) }

  let(:user) { FactoryGirl.create(:admin) }

  describe 'creation' do
    it 'is valid with an originally created course and a duplicate course' do
      expect {
        FactoryGirl.create(
          :course_purchase,
          user: user,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
        )
      }.to change{ CoursePurchase.count }.by(1)
    end

    it 'should allow multiple duplicate courses purchases from the same original course' do
      expect {
        FactoryGirl.create(
            :course_purchase,
            user: user,
            publish_record: original_course1_publish_record,
            course: duplicate_course1
        )
        FactoryGirl.create(
            :course_purchase,
            user: user,
            publish_record: original_course1_publish_record,
            course: duplicate_course2,
        )
      }.to change(CoursePurchase, :count).by(2)
    end

    it 'should detect if a course is duplicate' do
      expect {
        FactoryGirl.create(
            :course_purchase,
            user: user,
            publish_record: original_course1_publish_record,
            course: duplicate_course1
        )
        duplicate_course1.is_purchased_course?.should be_truthy
      }
    end
  end

  describe 'validations' do
    before do
      duplicate_course1_course_purchase = FactoryGirl.create(
          :course_purchase,
          user: user,
          course: duplicate_course1,
          publish_record: original_course1_publish_record
      )
      duplicate_course1.course_purchase = duplicate_course1_course_purchase
    end
    it 'should not allow original course to be the purchased course' do
      original_course2_publish_record
      FactoryGirl.build(
          :course_purchase,
          user: user,
          publish_record: original_course1_publish_record,
          course: original_course2
      ).should_not be_valid
    end

    # If PublishRecord's spec's 'should prevent purchased courses to be published' case is passing
    # but this is failing, the error can be due to the validator.
    it 'should not allow a duplicate course to be purchased from' do
      expect {
        duplicate_course1_publish_record = FactoryGirl.create(
            :publish_record,
            course: duplicate_course1,
            marketplace: test_marketplace
        )

        FactoryGirl.create(
            :course_purchase,
            user: user,
            publish_record: duplicate_course1_publish_record,
            course: duplicate_course2
        ).should_not be_valid
      }.to raise_error
    end

    it 'should not allow the same duplicate course to appear in multiple CoursePurchases' do
      FactoryGirl.create(
          :course_purchase,
          user: user,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
      )

      FactoryGirl.build(
          :course_purchase,
          user: user,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
      ).should_not be_valid
    end
  end
end
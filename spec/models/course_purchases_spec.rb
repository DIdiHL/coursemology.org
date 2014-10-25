require 'rails_helper'
RSpec.describe CoursePurchase, :type => :model do

  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(
      :user,
      email: 'course_purchase_test_user@example.com'
  ) }
  let(:marketplace) { FactoryGirl.create(:marketplace) }
  let(:original_course1) { FactoryGirl.create(:course) }
  let(:original_course1_publish_record) { FactoryGirl.create(
      :publish_record,
      marketplace: marketplace,
      course: original_course1
  ) }
  let(:duplicate_course1) { FactoryGirl.create(:course) }
  let(:duplicate_course2) { FactoryGirl.create(:course) }

  describe 'creation' do

    it 'is valid with an originally created course and a duplicate course' do
      expect {
        FactoryGirl.create(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: duplicate_course1
        )
      }.to change{ CoursePurchase.count }.by(1)
    end

    it 'should allow different users to purchase from the same course.' do
      expect {
        FactoryGirl.create(
            :course_purchase,
            user: user1,
            publish_record: original_course1_publish_record,
            course: duplicate_course1
        )
        FactoryGirl.create(
            :course_purchase,
            user: user2,
            publish_record: original_course1_publish_record,
            course: duplicate_course2,
        )
      }.to change(CoursePurchase, :count).by(2)
    end

    it 'should detect if a course is duplicate' do
      FactoryGirl.create(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: duplicate_course1
      )
      duplicate_course1.is_purchased_course?.should be_truthy
    end
  end

  describe 'validations' do
    let(:original_course2) { FactoryGirl.create(:course) }
    let(:original_course2_publish_record) { FactoryGirl.create(
        :publish_record,
        marketplace: marketplace,
        course: original_course2
    ) }

    it 'should not allow a published course to be the purchased course' do
      original_course2_publish_record
      FactoryGirl.build(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: original_course2
      ).should_not be_valid
    end

    # If PublishRecord's spec's 'should prevent purchased courses to be published' case is passing
    # but this is failing, the error can be due to the validator.
    it 'should not allow a purchase from a publish record that belongs to a duplicate course' do
      FactoryGirl.create(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: duplicate_course1
      )
      original_course1_publish_record.course = duplicate_course1
      FactoryGirl.build(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
      ).should_not be_valid
    end

    it 'should not allow invalid publish record to be purchased from' do
      original_course1_publish_record.course = duplicate_course1

      FactoryGirl.build(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
      ).should_not be_valid
    end

    it 'should not allow the same duplicate course to appear in multiple CoursePurchases' do
      FactoryGirl.create(
          :course_purchase,
          user: user1,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
      )
      FactoryGirl.build(
          :course_purchase,
          user: user2,
          publish_record: original_course1_publish_record,
          course: duplicate_course2
      ).should_not be_valid
    end

  end

end
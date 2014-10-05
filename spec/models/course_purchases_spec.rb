require 'spec_helper'
describe 'CoursePurchases' do
  let(:original_course1) { FactoryGirl.create(:course) }
  let(:original_course2) { FactoryGirl.create(:course) }
  let(:duplicate_course1) { FactoryGirl.create(:course) }
  let(:duplicate_course2) { FactoryGirl.create(:course) }
  let(:user) { FactoryGirl.create(:admin) }

  describe 'creation' do
    it 'is valid with an originally created course and a duplicate course' do
      expect {
        FactoryGirl.create(
          :course_purchase,
          user: user,
          original_course: original_course1,
          duplicate_course: duplicate_course1
        )
      }.to change{ CoursePurchase.count }.by(1)
    end

    it 'should allow multiple duplicate courses purchases from the same original course' do
      expect {
        FactoryGirl.create(
            :course_purchase,
            user: user,
            original_course: original_course1,
            duplicate_course: duplicate_course1
        )
        FactoryGirl.create(
            :course_purchase,
            user: user,
            original_course: original_course1,
            duplicate_course: duplicate_course2,
        )
      }.to change(CoursePurchase, :count).by(2)
    end
  end

  describe 'validations' do
    before do
      FactoryGirl.create(
          :course_purchase,
          user: user,
          original_course: original_course1,
          duplicate_course: duplicate_course1
      )
    end

    it 'should not allow duplicate course to be purchased' do
      FactoryGirl.build(
          :course_purchase,
          user: user,
          original_course: duplicate_course1,
          duplicate_course: duplicate_course2
      ).should_not be_valid
    end

    it 'should not allow the same duplicate course to appear in multiple CoursePurchases' do
      FactoryGirl.build(
          :course_purchase,
          user: user,
          original_course: original_course2,
          duplicate_course: duplicate_course1
      ).should_not be_valid
    end

    it 'should not allow originally created course to become purchased course' do
      FactoryGirl.build(
          :course_purchase,
          user: user,
          original_course: original_course2,
          duplicate_course: original_course1
      ).should_not be_valid
    end
  end
end
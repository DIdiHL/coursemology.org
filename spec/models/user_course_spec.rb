require 'rails_helper'

RSpec.describe UserCourse, type: :model do
  let(:lecturer) { FactoryGirl.create(:lecturer) }
  let(:buyer) { FactoryGirl.create(:lecturer, email: 'buyer@example.com') }
  let(:student) { FactoryGirl.create(:student) }

  let(:original_course) { FactoryGirl.create(:course, creator: lecturer) }
  let(:publish_record) { FactoryGirl.create(:publish_record, course: original_course, published: true) }
  let(:course_purchase) { FactoryGirl.create(:course_purchase, user: buyer, publish_record: publish_record) }
  let(:purchased_course) { FactoryGirl.create(:course, creator: lecturer, course_purchase: course_purchase) }

  let(:purchase_record) { FactoryGirl.create(:purchase_record, is_paid: true) }

  describe 'enrol a student' do
    context 'no vacancy' do
      it 'should prevent new enrolment' do
        expect(FactoryGirl.build(:user_course, course: purchased_course).valid?).to be_falsey
      end
    end

    context 'has vacancy' do
      before do
        purchase_record.course_purchase = course_purchase
        purchase_record.save
        course_purchase.reload
        puts course_purchase.purchase_records.inspect #fd
      end

      it 'should allow new enrolment' do
        expect(FactoryGirl.build(:user_course, course: purchased_course).valid?).to be_truthy
      end
    end

    context 'course is original' do
      it 'should allow new enrolment' do
        expect(FactoryGirl.build(:user_course, course: original_course).valid?).to be_truthy
      end
    end
  end
end

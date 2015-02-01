require 'rails_helper'
RSpec.describe CoursePurchase, :type => :model do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(
      :user,
      email: 'course_purchase_test_user@example.com'
  )}
  let(:original_course1) { FactoryGirl.create(:course) }
  let(:original_course1_publish_record) { FactoryGirl.create(
      :publish_record,
      course: original_course1
  )}
  let(:duplicate_course1) { FactoryGirl.create(:course, is_original_course: false) }
  let(:duplicate_course2) { FactoryGirl.create(:course, is_original_course: false) }


  describe 'create' do

    describe 'purchase from an originally created course' do
      subject { FactoryGirl.create(:course_purchase, user: user1, publish_record: original_course1_publish_record) }
      it 'should be allowed' do
        expect{ subject }.to change{ CoursePurchase.count }.by(1)
      end

      it 'should attach a duplicate course to the course purchase' do
        subject.course = duplicate_course1
        expect(duplicate_course1.course_purchase).to eq(subject)
      end
    end

    describe 'multiple purchases from the same course by different users' do
      it 'should be allowed' do
        expect{
            FactoryGirl.create(:course_purchase, user: user1, publish_record: original_course1_publish_record)
        }.to change{ CoursePurchase.count }.by(1)
        expect{
            FactoryGirl.create(:course_purchase, user: user2, publish_record: original_course1_publish_record)
        }.to change{ CoursePurchase.count }.by(1)
      end
    end

  end

  describe 'validations' do
    let(:original_course2) { FactoryGirl.create(:course) }
    let(:original_course2_publish_record) { FactoryGirl.create(
        :publish_record,
        course: original_course2
    )}
    let(:original_course1_purchase) { FactoryGirl.create(
        :course_purchase,
        user: user1,
        publish_record: original_course1_publish_record
    )}

    describe 'using originally created course as the duplicate course' do
      before do
        original_course2_publish_record
      end

      it 'should not be allowed' do
        expect { original_course1_purchase.course = original_course2 }.to raise_error
      end
    end

    describe 'purchasing from invalid publish record' do
      before do
        original_course1_publish_record.course = duplicate_course1
      end

      it 'should not be allowed' do
        expect(
            FactoryGirl.build(
              :course_purchase,
              user: user1,
              publish_record: original_course1_publish_record
            )
        ).not_to be_valid
      end
    end

    describe 'attaching the same duplicate course to different course purchases' do
      let(:original_course1_purchase2) { FactoryGirl.create(
          :course_purchase,
          user: user2,
          publish_record: original_course2_publish_record
      )}

      it 'should not be allowed' do
        original_course1_purchase.course = duplicate_course1
        expect { original_course1_purchse2.course = duplicate_course1 }.to raise_error
      end
    end

  end

  describe 'attaching purchase records' do
    let(:original_course1_purchase) { FactoryGirl.create(
        :course_purchase,
        user: user1,
        publish_record: original_course1_publish_record
    )}
    let(:purchase_record1) { FactoryGirl.create(
        :purchase_record,
        course_purchase: original_course1_purchase,
        seat_count: 10,
        is_paid: true
    )}

    let(:purchase_record2) { FactoryGirl.create(
        :purchase_record,
        course_purchase: original_course1_purchase,
        seat_count: 10,
        is_paid: true
    )}

    describe 'multiple purchase records' do
      it 'should increase capacity' do
        expect {
          purchase_record1
          purchase_record2
        }.to change{ original_course1_purchase.capacity }.by(20)
      end
    end

  end

end
require 'rails_helper'

RSpec.describe PublishRecord, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:original_course) { FactoryGirl.create(:course) }
  let(:publish_record) { FactoryGirl.create(:publish_record, course: original_course, published: false) }

  describe 'creation' do
    it 'should allow valid creation' do
      expect { FactoryGirl.create(:publish_record, course: original_course) }.to change(PublishRecord, :count).by(1)
    end
  end

  describe 'invalid creation' do
    let(:course_purchase) { FactoryGirl.create(
        :course_purchase,
        user: user,
        publish_record: publish_record
    )}
    let(:purchased_course) { FactoryGirl.create(:course, course_purchase_id: course_purchase.id, is_original_course: false) }
    before do
      purchased_course
    end

    it 'should prevent the same course to be published multiple times' do
      expect(FactoryGirl.build(:publish_record, course: original_course).valid?).to be_falsey
    end

    it 'should prevent duplicate courses to be published' do
      expect(FactoryGirl.build(:publish_record, course: purchased_course).valid?).to be_falsey
    end
  end

  describe 'validating' do

    describe 'publish record with negative price' do
      before do
        publish_record.price_per_seat = -1
        publish_record.save
        publish_record.reload
      end

      it 'should not change the original publish record' do
        expect(publish_record.price_per_seat).to eq(0)
      end
    end

    describe 'publish record with nil published' do
      before do
        publish_record.published = nil
        publish_record.save
        publish_record.reload
      end

      it 'should not change the original publish record' do
        expect(publish_record.published?).to eq(false)
      end
    end
  end
end

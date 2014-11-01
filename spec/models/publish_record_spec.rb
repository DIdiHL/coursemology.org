require 'rails_helper'

RSpec.describe PublishRecord, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:original_course) { FactoryGirl.create(:course) }

  describe 'creation' do
    it 'should allow valid creation' do
      expect { FactoryGirl.create(:publish_records, course: original_course) }.to change(PublishRecord, :count).by(1)
    end
  end

  describe 'invalid creation' do
    let(:publish_records) { FactoryGirl.create(:publish_records, course: original_course) }
    let(:course_purchases) { FactoryGirl.create(
        :course_purchases,
        user: user,
        publish_records: publish_record
    )}
    let(:purchased_course) { FactoryGirl.create(:course, course_purchase_id: course_purchase.id, is_original_course: false) }
    before do
      purchased_course
    end

    it 'should prevent the same course to be published multiple times' do
      expect(FactoryGirl.build(:publish_records, course: original_course).valid?).to be_falsey
    end

    it 'should prevent duplicate courses to be published' do
      expect(FactoryGirl.build(:publish_records, course: purchased_course).valid?).to be_falsey
    end
  end
end

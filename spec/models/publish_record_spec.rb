require 'rails_helper'

RSpec.describe PublishRecord, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:original_course) { FactoryGirl.create(:course) }
  let(:purchased_course) { FactoryGirl.create(:course) }

  describe 'creation' do
    it 'should allow valid creation' do
      expect { FactoryGirl.create(:publish_record, course: original_course) }.to change(PublishRecord, :count).by(1)
    end
  end

  describe 'invalid creation' do
    before do
      publish_record = FactoryGirl.create(:publish_record, course: original_course)
      course_purchase = FactoryGirl.create(
          :course_purchase,
          user: user,
          course: purchased_course,
          publish_record: publish_record
      )

    end
    it 'should prevent the same course to be published multiple times' do
      expect(FactoryGirl.build(:publish_record, course: original_course).valid?).to be_falsey
    end

    it 'should prevent purchased courses to be published' do
      expect(FactoryGirl.build(:publish_record, course: purchased_course).valid?).to be_falsey
    end
  end
end

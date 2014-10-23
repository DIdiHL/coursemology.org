require 'rails_helper'

RSpec.describe PublishRecord, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:original_course) { FactoryGirl.create(:course) }
  let(:purchased_course) { FactoryGirl.create(:course) }
  let(:test_marketplace) { FactoryGirl.create(:marketplace) }
  let(:test_marketplace2) { FactoryGirl.create(:marketplace) }

  describe 'creation' do
    it 'should allow valid creation' do
      expect { FactoryGirl.create(:publish_record, course: original_course, marketplace: test_marketplace) }.to change(PublishRecord, :count).by(1)
    end

    it 'should allow the same course to be published in multiple marketplaces' do
      expect {
        FactoryGirl.create(:publish_record, course: original_course, marketplace: test_marketplace)
        FactoryGirl.create(:publish_record, course: original_course, marketplace: test_marketplace2)
      }.to change(PublishRecord, :count).by(2)
    end
  end

  describe 'invalid creation' do
    before do
      publish_record = FactoryGirl.create(:publish_record, course: original_course, marketplace: test_marketplace)
      FactoryGirl.create(
          :course_purchase,
          user: user,
          course: purchased_course,
          publish_record: publish_record
      )
    end
    it 'should prevent the same course to be published in the same market multiple times' do
      FactoryGirl.build(:publish_record, course: original_course, marketplace: test_marketplace).should_not be_valid
    end

    it 'should prevent purchased courses to be published' do
      FactoryGirl.build(:publish_record, course: purchased_course, marketplace: test_marketplace).should_not be_valid
    end
  end
end

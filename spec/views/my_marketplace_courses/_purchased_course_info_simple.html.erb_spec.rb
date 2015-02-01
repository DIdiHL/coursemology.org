require 'rails_helper'

RSpec.describe 'Simple Course Info Components For Purchased Courses', type: :view do
  let(:original_course) { FactoryGirl.create(:course) }
  let(:publish_record) { FactoryGirl.create(:publish_record,
                                            course: original_course) }
  let(:purchased_course) { FactoryGirl.create(:course,
                                              is_original_course: false,
                                              duplication_origin_id: original_course.id) }
  let(:course_purchase) { FactoryGirl.create(:course_purchase, publish_record: publish_record) }

  subject { render partial: "my_marketplace_courses/purchased_course_info_simple",
                   locals: {course_purchase: course_purchase} }

  it 'should contain the course title' do
    expect(subject).to match(original_course.title)
  end

  context 'when the course has been duplicated' do
    before do
      course_purchase.course = purchased_course
    end

    it 'should contain the link to the course preference page' do
      expect(subject).to have_link(t('Marketplace.my_marketplace_courses.preference_btn_text.'),
                                   href: course_preferences_path(purchased_course.id))
    end
  end

  context 'when the course has not been duplicated' do
    context 'when the course purchase\'s capacity is  greater than 0' do
      before do
        FactoryGirl.create(:purchase_record, is_paid: true, course_purchase: course_purchase)
      end
      it 'should contain the link to the start date selection page' do
        expect(subject).to have_link(t('Marketplace.transaction.payment_confirmation.go_to_course_btn_text'),
                                     href: select_course_start_date_publish_record_course_purchase_path(
                                         course_purchase.publish_record, course_purchase))
      end
    end
  end

end

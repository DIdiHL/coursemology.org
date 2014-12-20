require 'rails_helper'

RSpec.describe 'Simple Course Info Components For Created Courses', type: :view do
  let(:course) { FactoryGirl.create(:course) }
  subject { render partial: "my_marketplace_courses/created_course_info_simple", locals: {course: course} }

  it 'should contain the course title' do
    expect(subject).to match(course.title)
  end

  it 'should contain publication settings button' do
    expect(subject).to have_link(
                           t('Marketplace.my_marketplace_courses.marketplace_preference_btn_text.',
                             href: course_preferences_path(course.id, _tab: 'marketplace')))
  end

  context 'when the course is not published' do

    context "because it doesn't have a publish record" do
      it 'should contain not published notice' do
        expect(subject).to match(t('Marketplace.my_marketplace_courses.not_published_notice'))
      end
    end

    context 'because its publish record sets published to false' do
      before do
        FactoryGirl.create(:publish_record, course: course, published: false)
      end

      it 'should contain not published notice' do
        expect(subject).to match(t('Marketplace.my_marketplace_courses.not_published_notice'))
      end
    end
  end

  context 'when course is published' do
    before do
      FactoryGirl.create(
          :publish_record,
          course: course,
      )
    end

    it 'should contain published notice' do
      expect(subject).to match(t('Marketplace.my_marketplace_courses.published_notice'))
    end

  end

end

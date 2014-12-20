require 'rails_helper'

RSpec.describe 'Simple Course Info Components For Purchased Courses', type: :view do
  let(:course) { FactoryGirl.create(:course) }
  subject { render partial: "my_marketplace_courses/purchased_course_info_simple", locals: {course: course} }

  it 'should contain the course title' do
    expect(subject).to match(course.title)
  end

  it 'should contain preference button' do
    expect(subject).to have_link(
                           t('Marketplace.my_marketplace_courses.preference_btn_text.',
                             href: course_preferences_path(course.id)))
  end

end

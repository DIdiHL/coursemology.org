require 'rails_helper'

RSpec.describe "my_marketplace_courses/show_created", type: :view do
  subject { render }
  let(:course) { FactoryGirl.create(:course) }


  it 'should display course title' do
    assign(:marketplace_course, course)

    expect(subject).to match(course.title)
  end

end
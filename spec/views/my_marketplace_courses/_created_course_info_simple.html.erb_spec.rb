require 'rails_helper'

RSpec.describe 'Simple Course Info Components', type: :view do
  let(:course) { FactoryGirl.create(:course) }
  subject { render partial: "my_marketplace_courses/created_course_info_simple", locals: {course: course} }

  it 'should contain the course title' do
    expect(subject).to match(course.title)
  end

  it 'should contain publication settings button' do
    expect(subject).to have_link(t('Marketplace.my_marketplace_courses.publication_settings_btn_label', href: my_marketplace_course_show_created_path(course.id)))
  end

  context 'when the course is published' do

    it 'should contain not published notice' do
      expect(subject).to match(t('Marketplace.my_marketplace_courses.not_published_notice'))
    end

  end

  context 'when course is published' do
    let(:market1) { FactoryGirl.create(:marketplace, name: 'market1') }
    let(:market2) { FactoryGirl.create(:marketplace, name: 'market2') }

    before do
      FactoryGirl.create(
          :publish_record,
          course: course,
          marketplace: market1
      )
      FactoryGirl.create(
          :publish_record,
          course: course,
          marketplace: market2
      )
    end

    it 'should contain market label' do
      expect(subject).to match(t('Marketplace.my_marketplace_courses.published_market_label'))
    end

    it 'should contain market names' do
      expect(subject).to match(market1.name)
      expect(subject).to match(market2.name)
    end

  end

end

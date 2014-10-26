require 'rails_helper'

RSpec.describe "my_marketplace_courses/show_created", type: :view do
  subject { render }
  let(:course) { FactoryGirl.create(:course) }
end
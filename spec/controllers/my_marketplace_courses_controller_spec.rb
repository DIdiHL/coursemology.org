require 'rails_helper'

RSpec.describe MyMarketplaceCoursesController, type: :controller do
  let(:lecturer) { FactoryGirl.create(:user, system_role_id: 3) }
  let(:course) { FactoryGirl.create(:course) }

  before do
    sign_in(lecturer)
  end

  describe 'GET show_created' do
    it 'should redirect unauthorized access to access denied page' do
      get :show_created, my_marketplace_course_id: course.id

      expect(response).to redirect_to(access_denied_path)
    end
  end
end
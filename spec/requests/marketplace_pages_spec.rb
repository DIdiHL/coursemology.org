require "spec_helper"

describe "MarketplacePages" do
  subject { page }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:course) { FactoryGirl.create(:course) }

  before do
    sign_in admin
    visit marketplace_index_path
  end

  it { should have_link("site-logo", href:marketplace_index_path) }

  describe "Marketplace Index" do
    it { should have_field("search_keywords") }
  end

end
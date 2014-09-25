require "spec_helper"

describe "MarketplacePages" do

  describe "Marketplace Entrypoint" do
    subject { page }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:course) { FactoryGirl.create(:course) }

    before do
      sign_in admin
    end

    describe "marketplace link display" do
      it { should have_link("Marketplace") }
    end
  end

end
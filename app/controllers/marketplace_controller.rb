class MarketplaceController < ApplicationController
  def url_options
    { marketplace_id: user_marketplace_id }.merge(super)
  end

  def show
  end

  def search
  end

  def edit
  end

  def index
  end
end

class MarketplaceController < ApplicationController
  def url_options
    { marketplace_id: user_marketplace_id }.merge(super)
  end

  def show
    search_keywords = get_search_keywords
  end

  def search

  end

  def edit
  end

  def index
  end

  #----------------------controller helpers ------------------------
  def get_search_keywords
    #precedence: GET Param's category and name > keyword string's counterparts.
    result = {}
    if params.has_key?(:category)
      result[:category] = params[:category]
    end

    if params.has_key?(:name)
      resultp[:name] = params[:name]
    end

    if params.has_key?(:keywords)
      extract_keywords_to(result)
    end
  end

  def extract_keywords_to(dest)
    if (dest.is_a?(Hash))
      
    end
  end
end

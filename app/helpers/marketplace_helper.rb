module MarketplaceHelper
  def get_suggested_categories
    #get suggested categories based on the user's previous browsing and search
    #history
    categories = [
        {:category => "C++"},
        {:category => "Java"},
        {:category => "Python"},
        {:category => "Javascript"}
    ]
    get_marketplace_search_parameters categories
  end

  def get_marketplace_search_parameters(search_parameters)
    result = []
    if search_parameters.kind_of?(Array)
      search_parameters.each { |element|
        if element.kind_of?(Hash)
          element.except(:href)
          element[:href] = marketplace_search_path(element);
          result << element
        end
      }
    end
    result
  end

  def get_name_from_suggested_category(category)
    result = ""
    if verify_suggested_category(category)
      result = category[:category]
    end
    result
  end

  def get_href_from_suggested_category(category)
    result = ""
    if verify_suggested_category(category)
      result = category[:href]
    end
    result
  end

  def verify_suggested_category(category)
    return category.is_a?(Hash) &&
        category.has_key?(:category) &&
        category.has_key?(:href)
  end
end

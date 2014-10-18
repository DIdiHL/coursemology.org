module MarketplacesHelper
  def get_suggested_categories(marketplace_id)
    #get suggested categories based on the user's previous browsing and search
    #history
    categories = [
        {:category => "C++"},
        {:category => "Java"},
        {:category => "Python"},
        {:category => "Javascript"}
    ]
    get_marketplace_search_paths(marketplace_id, categories)
  end

  def get_marketplace_search_paths(marketplace_id, search_options_collection)
    result = []
    if search_options_collection.kind_of?(Array)
      search_options_collection.each { |element|
        if element.kind_of?(Hash)
          element.except(:href)
          element[:href] = marketplace_search_path(:marketplace_id => marketplace_id,
                                                   :keywords => get_marketplace_search_keywords(element))
          result << element
        end
      }
    end
    result
  end

  def get_marketplace_search_keywords(search_options)
    result = ''
    comma = ''
    if search_options.is_a?(Hash)
      search_options.each { |key, value|
        result += "#{comma}#{key}:#{value}"
        comma = ','
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

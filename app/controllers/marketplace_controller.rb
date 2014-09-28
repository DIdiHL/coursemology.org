class MarketplaceController < ApplicationController
  def url_options
    { marketplace_id: user_marketplace_id }.merge(super)
  end

  def show
    search_keywords = get_search_keywords
  end

  def search
    @keywords = get_search_keywords
    keyword_results = do_search_by_keywords(@keywords)
    @final_results = intersect_keyword_results(keyword_results)
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
      result[:name] = params[:name]
    end

    if params.has_key?(:keywords)
      extract_keywords_to(result)
    end
    result
  end

  def extract_keywords_to(dest)
    if (dest.is_a?(Hash))
      keywords_string = params[:keywords]
      if keywords_string.is_a?(String)
        remaining_keywords = keywords_string
        search_grammar = /([A-Z|a-z]+:?[A-z|0-9| ]+)(,)?/
        keywords =
            keywords_string.scan(search_grammar).map { |element| element[0] }
        keywords.each { |element|
          remaining_keywords = remaining_keywords.sub(element, "")
          key, value = element.split(":")
          if not dest.has_key?(key)
            dest[key] = value
          end
        }

        remaining_keywords = remaining_keywords.gsub(",", "")
        if not remaining_keywords.empty?
          # These are used to perform fuzzy search
          dest[:fuzzy] = remaining_keywords
        end
      end
    end
  end

  def do_search_by_keywords(keywords)
    results = {}
    if keywords.is_a?(Hash)
      keywords.each { |key, value|
        results[key] = do_search_by_key_value(key, value)
      }
    end
    results
  end

  def do_search_by_key_value(key, value)
    # TODO implement search logic
  end

  def intersect_keyword_results(keyword_results)
    # TODO implement intersection logic
    # Only display results that match all keywords.
  end
end

class MarketplacesController < ApplicationController

  def show
    search_keywords = get_search_keywords
  end

  def search
    @keywords = get_search_keywords
    keyword_results = do_search_by_keywords(@keywords)
    @final_results = intersect_keyword_results(keyword_results)
    #fd section
    @final_results = [Course.find(96), Course.find(97)]
  end

  def edit
  end

  def index
    if !params.has_key?(:marketplace_id)
        params[:marketplace_id] = user_marketplace_id;
    end
  end

  #----------------------controller helpers ------------------------
  def get_search_keywords
    #precedence: GET Param's category and name > keyword string's counterparts.
    result = {}
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
        search_grammar = /\s?((\w*):\s?)?([\w|+|#]+),?/
        keywords = keywords_string.scan(search_grammar)

        keyword_key_index = 1
        keyword_value_index = 2
        keywords.each { |keyword_group|
          if keyword_group[keyword_key_index]
            dest[keyword_group[keyword_key_index]] = keyword_group[keyword_value_index]
          else
            if !dest[:fuzzy]
              dest[:fuzzy] = keyword_group[keyword_value_index]
            else
              dest[:fuzzy] += ' ' + keyword_group[keyword_value_index]
            end
          end
        }
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

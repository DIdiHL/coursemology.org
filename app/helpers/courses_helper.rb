module CoursesHelper
  def filter_params
    result = @show_creators.to_query('show_creators')
    if params[:free]
      result.concat('&' + true.to_query('free'))
    end

    if params[:paid]
      result.concat('&' + true.to_query('paid'))
    end
    result
  end
end

module MyMarketplaceCoursesHelper
  def check_tab_status(tab_name, default_name)
    result = ''
    if !params[:active] && tab_name == default_name || params[:active] == tab_name
      result = 'active'
    end
  end
end

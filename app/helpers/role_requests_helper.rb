module RoleRequestsHelper
  def get_form_action_url()
    if controller.action_name == 'new'
      return get_form_action_url_for_new
    else
      return get_form_action_url_for_update
    end
  end

  def get_form_action_url_for_new()
    if params[:redirect]
      return role_requests_path(redirect: params[:redirect])
    else
      return role_requests_path
    end
  end

  def get_form_action_url_for_update()
    if params[:redirect]
      return role_request_path(redirect: params[:redirect])
    else
      return role_request_path
    end
  end
end

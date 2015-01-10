class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # If a user is signed in then he is trying to link a new account
    if user_signed_in?
      auth = request.env["omniauth.auth"]
      if current_user && current_user.persisted? && current_user.update_external_account(auth)
        flash[:success] = "Your facebook account has been linked to this user account successfully."
      else
        flash[:error] = "The Facebook account has been linked with another user."
      end
      redirect_to edit_user_path(current_user)
    else
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
      if @user.persisted?
        # save fb access token in the session
        session[:fb_access_token] = request.env["omniauth.auth"]["credentials"]["token"]
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  def paypal
    # There is no intention to allow paypal login. This only serves to verify the user's
    # PayPal identity so that payouts can be made to him via PayPal.
    if user_signed_in? and current_user.payout_identity
      current_user.payout_identity.receiver_id = request.env["omniauth.auth"][:info][:email]
      current_user.payout_identity.save!
      @courses = current_user.courses
      if @courses.count == 0
        redirect_to my_courses_path, notice: t('Marketplace.payout_identity.paypal_verified_notice')
      else
        course_id = session[:payout_identity_request_course]
        course_id ||= @courses.count == 1 ? @courses.first.id :
            current_user.user_courses.order("last_active_time desc").first.course.id
        redirect_to course_preferences_path(course_id, _tab: 'marketplace'),
                    notice: t('Marketplace.payout_identity.paypal_verified_notice')
      end
    else
      redirect_to access_denied_path, alert: t('Marketplace.payout_identity.not_signed_in_error')
    end
  end
end

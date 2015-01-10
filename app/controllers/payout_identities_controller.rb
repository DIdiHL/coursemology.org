class PayoutIdentitiesController < ApplicationController
  load_and_authorize_resource

  def create
    save_course_id_to_session
    @payout_identity.user = current_user
    @payout_identity.save!
    redirect_to user_omniauth_authorize_path(@payout_identity.receiver_type)
  end

  def update
    save_course_id_to_session
    @payout_identity.receiver_type = params[:payout_identity][:receiver_type]
    redirect_to user_omniauth_authorize_path(@payout_identity.receiver_type)
  end

  def save_course_id_to_session
    if params[:course] and params[:course][:id]
      session[:payout_identity_request_course] = params[:course][:id]
    end
  end
end
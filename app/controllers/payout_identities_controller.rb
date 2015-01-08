class PayoutIdentitiesController < ApplicationController
  load_and_authorize_resource

  def create
    @payout_identity.user = current_user
    @payout_identity.save!
    redirect_to verify_identity_payout_identity_path(@payout_identity)
  end

  def verify_identity
    # TODO paypal identity
  end
end
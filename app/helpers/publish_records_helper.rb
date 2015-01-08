module PublishRecordsHelper
  def get_payout_identity
    result = current_user.payout_identity
    result ||= PayoutIdentity.new
  end
end

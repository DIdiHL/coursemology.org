class PublishRecordsController < ApplicationController
  before_filter :authorize_preference_setting

  def authorize_preference_setting
    authorize! :manage, :course_preference
  end

  def update
    publish_record = find_or_create_publish_record
    begin
      set_publish_record_data_and_save(publish_record)
    rescue => e
      flash[:error] = e.message
    end
  end

  def find_or_create_publish_record
    if should_create
      return PublishRecord.new
    else
      return PublishRecord.find(params[:publish_record_id])
    end
  end

  def should_create
    not params[:publish_record_id]
  end

  def set_publish_record_data_and_save(publish_record)
    data = params[:publish_record]
    publish_record.price_per_seat = data[:price_per_seat]
    publish_record.published = data[:published]
    publish_record.course_id = params[:course_id]
    publish_record.save!
  end

  def redirect_back
    redirect_path = params[:redirect]
    redirect_path ||= course_preferences_path(params[:course_id], _tab: 'marketplace')

    respond_to do |format|
      format.html { redirect_to redirect_path }
    end
  end

end

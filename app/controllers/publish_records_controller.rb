class PublishRecordsController < ApplicationController
  load_and_authorize_resource :publish_record

  def update
    begin
      set_publish_record_data_and_save(@publish_record)
    rescue => e
      flash[:error] = e.message
    end
    my_redirect
  end

  def set_publish_record_data_and_save(publish_record)
    data = params[:publish_record]
    publish_record.price_per_seat = data[:price_per_seat]
    publish_record.published = data[:published]
    publish_record.course_id = params[:course_id]
    publish_record.save!
  end

  def my_redirect
    redirect_path = params[:redirect]
    redirect_path ||= course_preferences_path(params[:course_id], _tab: 'marketplace')

    respond_to do |format|
      format.html { redirect_to(redirect_path) }
    end
  end

end

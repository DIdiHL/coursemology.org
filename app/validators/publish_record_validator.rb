class PublishRecordValidator < ActiveModel::Validator
  def validate(publish_record)
    if publish_record.course.is_duplicate_course?
      publish_record.errors[:course] << "Purchased courses can't be resold in the marketplace"
    end
  end
end

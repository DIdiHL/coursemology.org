class PublishRecordValidator < ActiveModel::Validator
  def validate(publish_record)
    if PublishRecord.where(course_id: publish_record.course.id, marketplace_id: publish_record.marketplace.id).any?
      publish_record.errors[:course] << 'A course can only be published in a marketplace once.'
    end

    if publish_record.course.is_purchased_course?
      publish_record.errors[:course] << "Purchased courses can't be resold in the marketplace"
    end
  end
end

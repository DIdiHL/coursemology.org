class CoursePurchaseValidator < ActiveModel::Validator

  def validate(course_purchase)
    publish_record = course_purchase.publish_record
    course = course_purchase.course
    should_have_valid_publish_record(course_purchase, publish_record)
    should_have_valid_course(course_purchase, course)
  end

  def should_have_valid_publish_record(course_purchase, publish_record)
    if not PublishRecord.where(marketplace_id: publish_record.marketplace_id, course_id: publish_record.course_id).any?
      course_purchase.errors[:publish_record] << 'The given publish record is not found.'
    end

    if publish_record.course.is_purchased_course?
      course_purchase.errors[:publish_record] << 'The publish record should not belong to a duplicate course.'
    end
  end

  def should_have_valid_course(course_purchase, course)
    if course.is_published_in_marketplace?
      course_purchase.errors[:course] << "A published course can't be the purchased course."
    end

    if Course.find(course.id).course_purchase
      course_purchase.errors[:course] << "A purchased course can't appear in multiple purchases"
    end
  end

end
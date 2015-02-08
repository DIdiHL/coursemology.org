class CoursePurchaseValidator < ActiveModel::Validator

  def validate(course_purchase)
    publish_record = course_purchase.publish_record
    course = course_purchase.course
    should_have_valid_publish_record(course_purchase, publish_record)
    should_have_valid_course(course_purchase, course)
  end

  def should_have_valid_publish_record(course_purchase, publish_record)
    if not publish_record
      return
    end

    existing_record = PublishRecord.where(course_id: publish_record.course_id)
    if not existing_record.any?
      course_purchase.errors[:publish_records] << 'The given publish record is not found.'
    elsif existing_record[0].course_id != publish_record.course_id
      course_purchase.errors[:publish_records] << 'The given publish record contains incorrect data.'
    end

    if publish_record.course.is_duplicate_course?
      course_purchase.errors[:publish_records] << 'The publish record should not belong to a duplicate course.'
    end
  end

  def should_have_valid_course(course_purchase, course)
    if not course
      return
    end

    if course.is_original_course?
      course_purchase.errors[:course] << " - an original course can't be the purchased course."
    end

    if course.is_published_in_marketplace?
      course_purchase.errors[:course] << "- a published course can't be the purchased course."
    end
  end

end
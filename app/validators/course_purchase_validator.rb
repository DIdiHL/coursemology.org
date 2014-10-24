class CoursePurchaseValidator < ActiveModel::Validator
  def validate(record)
    unless verify_purchased_course(record)
      record.errors[:course] << "Purchased course doesn't match the publish record."
    end

    publish_record = PublishRecord.find(record.publish_record.id)
    if not publish_record.course
      record.errors[:publish_record] << "The publish record doesn't contain any course"
    elsif publish_record.course.is_purchased_course?
      record.errors[:course] << "A purchased course can't be purchased from."
    end

    purchased_course = Course.find(record.course.id)
    if not purchased_course.publish_records.blank?
      record.errors[:course] << "A published course can't possibly be a purchased course."
    end

    if purchased_course and purchased_course.is_purchased_course?
      record.errors[:course] << 'Duplicate course already been purchased. You probably want to create a new SeatPurchase instead of CoursePurchase.'
    end
  end

  def verify_purchased_course(record)
    original_course_publish_record = record.publish_record
    purchased_course = record.course
    unless course_fields_complete?(original_course_publish_record, purchased_course) and
        courses_match?(original_course_publish_record.course, purchased_course)
      return false
    end
    true
  end

  def course_fields_complete?(publish_record, course)
    publish_record and course
  end

  def courses_match?(original_course, purchased_course)
    unless original_course.title == purchased_course.title
      return false
    end
    true
  end
end
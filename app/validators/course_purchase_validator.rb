class CoursePurchaseValidator < ActiveModel::Validator
  def validate(record)
    unless verify_purchased_course(record)
      record.errors[:course] << "Purchased course doesn't match the publish record."
    end

    if not record.course.publish_records.blank?
      record.errors[:course] << "A published course can't possibly be a purchased course."
    end

    duplicate_course = record.course
    if duplicate_course and Course.find(duplicate_course.id).is_purchased_course?
      record.errors[:course] << 'Duplicate course already been purchased. You probably want to create a new SeatPurchase instead of CoursePurchase.'
    end
  end

  def verify_purchased_course(record)
    original_course = record.publish_record.course
    duplicate_course = record.course
    unless original_course.title == duplicate_course.title and original_course.creator == duplicate_course.creator
      return false
    end
    true
  end
end
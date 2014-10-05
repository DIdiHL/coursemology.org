class CoursePurchaseValidator < ActiveModel::Validator
  def validate(record)
    unless record.original_course.is_original_course?
      record.errors[:original_course] << "Purchase must be made to an originally created course. Purchased course can't be resold."
    end

    if !record.duplicate_course.purchase_records.blank?
      record.errors[:duplicate_course] << "A course that has already been purchased can't be the duplicate course"
    end

    duplicate_course = record.duplicate_course
    if duplicate_course and Course.find(duplicate_course.id).is_purchased_course?
      record.errors[:duplicate_course] << 'Duplicate course already been purchased. You probably want to create a new SeatPurchase instead of CoursePurchase.'
    end
  end
end
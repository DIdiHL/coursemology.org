class CourseValidator < ActiveModel::Validator
  def validate(course)
    if course.course_purchase and course.publish_record
      course.errors[:marketplace_type] << 'course_purchase and publish_records are mutually exclusive.'
    end

    if course.course_purchase_id_changed? and not (course.course_purchase_id_was === nil)
      course.errors[:course_purchase_id] << 'should never be changed after set the course is created'
    end
  end
end
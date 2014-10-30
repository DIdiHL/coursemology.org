class CourseValidator < ActiveModel::Validator
  def validate(course)
    if course.course_purchase and not course.publish_record
      course.errors[:marketplace_type] << 'course_purchase and public_records are mutually exclusive.'
    end
  end
end
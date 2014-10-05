class CourseMarketplaceTypeValidator < ActiveModel::Validator
  def validate(course)
    if course.origin_record and not course.purchase_records.blank?
      course.errors[:marketplace_type] << 'origin_record and purchase_records are mutually exclusive. A course can only have one of them'
    end
  end
end
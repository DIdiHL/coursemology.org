class UserCourseValidator < ActiveModel::Validator
  def validate(user_course)
    if user_course.role_id == Role.student.first.id
      if no_vacancy?(user_course)
        puts user_course.course.course_purchase.vacancy #fd
        user_course.errors[:no_vacancy] = I18n.t('Marketplace.course.no_vacancy_error')
      end
    end
  end

  def no_vacancy?(user_course)
    user_course.course and
        user_course.course.course_purchase and
        user_course.course.course_purchase.vacancy <= 0
  end
end
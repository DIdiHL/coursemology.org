require 'pp'
include ApplicationHelper

def show_page
  save_page Rails.root.join( 'public', 'capybara.html' )
  %x(launchy http://0.0.0.0:3000/capybara.html)
end

def sign_in(user)
  visit new_user_session_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out()
  click_link 'Sign out'
end

def create_course(course)
  visit my_courses_path
  click_link "New Course"
  fill_in 'course_title', with: course.title
  fill_in 'course_description', with: course.description
  click_button "Create"
end

def course_enrol_student(course, student)
  #find the real course created by capybara
  real_course = Course.where(:title => course.title).order('id DESC').first
  role = Role.find(student.system_role_id)
  real_course.enrol_user(student, role)
end

def create_training(course, training)
  visit course_assessment_trainings_path(course)
  click_link 'New Training'
  fill_in 'assessment_training_title', with: training.title
  fill_in 'assessment_training_description', with: training.description
  fill_in 'assessment_training_exp', with: training.exp
  fill_in 'assessment_training_bonus_exp', with: training.bonus_exp
  fill_in 'assessment_training_open_at', with: training.open_at
  fill_in 'assessment_training_bonus_cutoff_at', with: training.bonus_cutoff_at
  check 'assessment_training_published'
end
  

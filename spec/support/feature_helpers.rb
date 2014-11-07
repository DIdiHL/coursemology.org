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

def create_course(course)
  visit my_courses_path
  click_link "New Course"
  fill_in 'course_title', with: course.title
  fill_in 'course_description', with: course.description
  click_button "Create"
end

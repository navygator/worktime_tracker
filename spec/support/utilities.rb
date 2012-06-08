include ApplicationHelper

def sign_in(employee)
  visit signin_path
  fill_in "Email", with: employee.email
  fill_in "Password", with: employee.password
  click_button "Sign in"
  post sessions_path, {:session => { :email => employee.email, :password => employee.password }}
end

def sign_in_by_controller(employee)
  controller.sign_in employee
end
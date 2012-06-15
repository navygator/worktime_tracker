include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  post sessions_path, {:session => { :email => user.email, :password => user.password }}
end

def sign_in_by_controller(user)
  controller.sign_in user
end
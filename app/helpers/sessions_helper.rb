module SessionsHelper
  def sign_in(employee)
    session[:remember_token] = employee.remember_token
    current_user = employee
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user = nil
    session.delete(:remember_token)
  end

  def current_user=(employee)
    @current_user = employee
  end

  def current_user
    @current_user ||= Employee.where(:remember_token => session[:remember_token]).first
  end
end

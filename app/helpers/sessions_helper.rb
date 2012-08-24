module SessionsHelper
  def sign_in(user)
    session[:remember_token] = user.remember_token
    current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user = nil
    session.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.where(:remember_token => session[:remember_token]).first
  end

  def current_user?(user)
    user == current_user
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def restricted_registered
    redirect_to root_path
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
end

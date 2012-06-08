class SessionsController < ApplicationController
  force_ssl if Rails.env.production?

  def new
  end

  def create
    employee = Employee.find_by_email(params[:session][:email])
    if employee && employee.authenticate(params[:session][:password])
      sign_in employee
      redirect_back_or employee
    else
      flash.now[:error] = "Invalid email/password combination!"
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:info] = "You are logged out"
    redirect_to root_path
  end
end

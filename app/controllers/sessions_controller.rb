class SessionsController < ApplicationController
  def new
  end

  def create
    employee = Employee.find_by_email(params[:sessions][:email])
    if employee && employee.authenticate(params[:sessions][:password])
      sign_in employee
      redirect_to employee_path employee
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

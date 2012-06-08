class EmployeesController < ApplicationController
  force_ssl only: [:new, :create] if Rails.env.production?

  before_filter :signed_user, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      flash[:success] = 'Employee was successfully created'
      redirect_to @employee
    else
      render 'new'
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def edit
  end

  def update
    if @employee.update_attributes(params[:employee])
      flash[:success] = "Profile successfully updated"
      redirect_to employee_path @employee
    else
      render 'edit'
    end
  end

private
  def signed_user
    store_location
    redirect_to signin_path, notice: "Please sign in" unless signed_in?
  end

  def correct_user
    @employee = Employee.find(params[:id])
    redirect_to root_path, error: "You are not allowed" unless current_user?(@employee)
  end
end

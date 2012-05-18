class EmployeesController < ApplicationController
  force_ssl only: [:new, :create] if Rails.env.production?

  def index
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
end

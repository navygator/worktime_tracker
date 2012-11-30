class UsersController < ApplicationController
  force_ssl only: [:new, :create] if Rails.env.production?

  before_filter :not_signed_user, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  before_filter :signed_user, :only => [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'user was successfully created'
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @work_items = @user.work_items
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated"
      redirect_to user_path @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user was successfully deleted"
    redirect_to users_path
  end

private
  def signed_user
    redirect_to root_path if signed_in?
  end

  def not_signed_user
    store_location
    redirect_to signin_path, notice: "Please sign in" unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, error: "You are not allowed" unless (current_user?(@user) || current_user.admin?)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end

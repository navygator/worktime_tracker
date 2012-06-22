class RelationsController < ApplicationController
  def index
    @approvers = User.where(:approver => true)
    @users = User.all
  end

  def new
  end

  def create
  end

  def destroy
  end
end

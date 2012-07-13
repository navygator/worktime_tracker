class RelationsController < ApplicationController
  respond_to :html, :js, :json

  def index
    @approvers = User.where(:approver => true)
  end

  def new
    approver = User.find(params[:approver_id])
    @relation = approver.relations.build
    @users = User.all
  end

  def create
  end

  def destroy
  end
end

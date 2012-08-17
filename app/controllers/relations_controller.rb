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
    approver = User.find(params[:relation][:approver_id])
    @relation = approver.relations.build(:approved_id => params[:relation][:approved_id])
    if @relation.save
    else
      @users = User.all
      respond_with @relation
    end
  end

  def destroy
  end
end

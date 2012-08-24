class RelationsController < ApplicationController
  #before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

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
      flash.now[:success] = "Successfully"
    else
      flash.now[:error] = "Can't add user"
      @users = User.all
      respond_with @relation
    end
  end

  #it stinks
  def destroy
    if @relation.nil?
      flash.now[:success] = "You are not allowed this"
      @relation = Relation.find(params[:id])
    else
      @relation.destroy
      flash.now[:success] = "Approving successfully removed"
    end
  end

  private
  #it stinks
  def authorized_user
    if current_user.admin?
      @relation = Relation.find(params[:id])
    else
      @relation = current_user.relations.find_by_id(params[:id])
    end
  end

end

class RelationsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  respond_to :html, :js, :json

  def index
    @approvers = User.where(:approver => true)
  end

  def new
    approver = User.find(params[:approver_id])
    @relation = approver.relations.build
    @users = User.not_approved_by(approver)
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

  def destroy
      @relation.destroy
      flash.now[:warn] = "Approving successfully removed"
  end

  private
  def authorized_user
    @relation = current_user.relations.find_by_id(params[:id])
    @relation ||= @relation = Relation.find(params[:id]) if current_user.admin?

    if @relation.nil?
      flash[:error] = "You are not allowed this"
      respond_to do |format|
        format.js { render :js => "window.location = '/relations'" }
        format.html { redirect_to relations_path }
      end
    end
  end
end

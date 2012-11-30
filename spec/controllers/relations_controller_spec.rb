require 'spec_helper'

describe RelationsController do
  render_views

  let(:approver) { FactoryGirl.create(:user) }
  before do
    approver.toggle!(:approver)
    sign_in_by_controller(approver)
  end


  describe "GET 'new'" do
    let(:approving) { FactoryGirl.create(:user) }
    before do
      @relation = approver.relations.build(approved_id: approving.id)
      @relation.save!
    end

    it "should respond to ajax requests" do
      xhr :get, :new, :approver_id => approver.id
      response.should be_success
    end
  end
end

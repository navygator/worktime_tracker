require 'spec_helper'

describe "WorkItemPages" do
  subject { page }

  let(:approver) { FactoryGirl.create(:user) }
  before do
    approver.toggle!(:approver)
    sign_in(approver)
  end

  describe "create work item" do
    before { visit user_path(user) }

  end
end

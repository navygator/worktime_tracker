require 'spec_helper'

describe "RelationPages" do
  subject { page }

  let(:approver) { FactoryGirl.create(:user) }
  before { approver.toggle!(:approver) }

  describe "index" do
    let(:approving) { FactoryGirl.create(:user) }
    before do
      visit relations_path
    end

    it { should have_selector("h1", "Approvers") }
    it { should have_selector("title", text: "Approvers") }
    it { should have_selector("td", content: approver.short_name) }
  end
end

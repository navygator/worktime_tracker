require 'spec_helper'

describe "RelationPages" do
  subject { page }

  let(:approver) { FactoryGirl.create(:user) }
  before do
    approver.toggle!(:approver)
    sign_in(approver)
  end

  describe "index" do
    let(:approving) { FactoryGirl.create(:user) }
    before do
      @relation = approver.relations.build(approved_id: approving.id)
      @relation.save!
      visit relations_path
    end

    it { should have_selector("h1", text: I18n.t(:relations)) }
    it { should have_selector("title", text: I18n.t(:relations)) }
    it { should have_selector("td", content: approver.short_name) }
    it { should have_selector("td", content: approving.short_name) }
    it { should have_link("delete", href: relation_path(@relation)) }
  end
end

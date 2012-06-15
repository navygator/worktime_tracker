require 'spec_helper'

describe Approving do
  let(:approver) { FactoryGirl.create(:user) }
  let(:approved) { FactoryGirl.create(:user) }

  before do
    @approving = approver.approvings.build(approved_id: approved.id)
  end

  subject { @approving }
  describe "validations" do

    describe "require approved_id" do
      before { @approving.approved_id = nil }
      it { should_not be_valid }
    end

    describe "require approver_id" do
      before { @approving.approver_id = nil }
      it { should_not be_valid }
    end
  end
end

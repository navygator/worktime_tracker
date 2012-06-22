require 'spec_helper'

describe Relation do
  let(:approver) { FactoryGirl.create(:user) }
  let(:approved) { FactoryGirl.create(:user) }

  before do
    @relation = approver.relations.build(approved_id: approved.id)
  end

  subject { @relation }

  it { should respond_to(:approver) }
  it { should respond_to(:approved) }

  describe "validations" do
    describe "require approved_id" do
      before { @relation.approved_id = nil }
      it { should_not be_valid }
    end

    describe "require approver_id" do
      before { @relation.approver_id = nil }
      it { should_not be_valid }
    end
  end

  it "should be right approving user" do
    @relation.approver.should eq approver
  end

  it "should be right approved user" do
    @relation.approved.should eq approved
  end

  describe "dependent destroy" do
    before { @relation.save! }
    it "should destroy approving when destroy approved user" do
      approved.destroy
      expect { Relation.find(@relation) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy approving when destroy approver user" do
      approver.destroy
      expect { Relation.find(@relation) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

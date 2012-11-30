require 'spec_helper'

describe WorkItem do
  let(:valid_attributes) { { description: "Overwork for test", type_id: 1,
                             start_at: Time.now, end_at: 1.hour.from_now } }
  before do
    @user = FactoryGirl.create(:user)
    @item = @user.work_items.build(valid_attributes)
  end

  subject { @item }

  it { should respond_to(:description) }
  it { should respond_to(:end_at) }
  it { should respond_to(:start_at) }
  it { should respond_to(:type_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:workflow_state) }

  it { should be_valid }

  it "should create new item with valid attributes given" do
      lambda do
        @user.work_items.create!(valid_attributes)
      end.should change(WorkItem, :count).by(1)
  end

  #
  # description
  #
  describe "description" do
    it "should require" do
      @user.work_items.build(valid_attributes.merge(description: "" )).should_not be_valid
    end

    it "should be less than 51 symbols" do
      @user.work_items.build(valid_attributes.merge(description: "a"*51 )).should_not be_valid
    end
  end

  #
  # type_id
  #
  describe "type_id" do
    it "should require" do
      @user.work_items.build(valid_attributes.merge(type_id: "" )).should_not be_valid
    end
  end

  #
  # start_at
  #
  describe "start_at" do
    it "should require" do
      @user.work_items.build(valid_attributes.merge(start_at: nil )).should_not be_valid
    end
  end

  #
  # end_at
  #
  describe "end_at" do
    it "should require" do
      @user.work_items.build(valid_attributes.merge(end_at: nil )).should_not be_valid
    end
  end
end

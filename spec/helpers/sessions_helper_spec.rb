require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SessionsHelper do
  let(:employee) { FactoryGirl.create(:employee) }
  before { helper.sign_in(employee) }

  describe "#sign_in" do
    it "should save remember token to session object" do
      session[:remember_token].should eq employee.remember_token
    end
  end

  describe "#current_user" do
    it "should return signed in employee" do
      helper.current_user.should eq employee
    end
  end

  describe "#signed_in?" do
    it "should return true if user signed in" do
      helper.signed_in?.should be_true
    end
  end

  describe "#current_user?" do
    it "should return true if it's current user" do
      helper.current_user?(employee).should be_true
    end

    it "should return false if it's not current user" do
      another_employee = FactoryGirl.create(:employee)
      helper.current_user?(another_employee).should be_false
    end
  end

  describe "#store_location" do
    before { helper.request.path = employees_path }

    it "should store session key 'return_to'" do
      helper.store_location
      session[:return_to].should eq employees_path
    end

    describe "#redirect_back_or" do
      it "should redirect to stored location"
    end
  end
end

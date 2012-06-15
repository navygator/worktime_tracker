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
  let(:user) { FactoryGirl.create(:user) }
  before { helper.sign_in(user) }

  describe "#sign_in" do
    it "should save remember token to session object" do
      session[:remember_token].should eq user.remember_token
    end
  end

  describe "#current_user" do
    it "should return signed in user" do
      helper.current_user.should eq user
    end
  end

  describe "#signed_in?" do
    it "should return true if user signed in" do
      helper.signed_in?.should be_true
    end
  end

  describe "#current_user?" do
    it "should return true if it's current user" do
      helper.current_user?(user).should be_true
    end

    it "should return false if it's not current user" do
      another_user = FactoryGirl.create(:user)
      helper.current_user?(another_user).should be_false
    end
  end

  describe "#store_location" do
    before { helper.request.path = users_path }

    it "should store session key 'return_to'" do
      helper.store_location
      session[:return_to].should eq users_path
    end

    describe "#redirect_back_or" do
      it "should redirect to stored location"
    end
  end
end

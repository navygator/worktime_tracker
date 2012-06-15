require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    let(:user) { FactoryGirl.create(:user) }

    describe "with wrong user" do
      let(:another_user) { FactoryGirl.create(:user, email: "other@example.com") }
      before { sign_in_by_controller(user) }

      it "should redirect to root" do
        get :edit, id: another_user
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT 'update'" do
    let(:user) { FactoryGirl.create(:user) }

    describe "with wrong user" do
      let(:another_user) { FactoryGirl.create(:user, email: "other@example.com") }
      before { sign_in_by_controller(user) }

      it "should redirect to root" do
        put :update, id: another_user, user: another_user
        response.should redirect_to(root_path)
      end
    end
  end
end
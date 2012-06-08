require 'spec_helper'

describe EmployeesController do

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    let(:employee) { FactoryGirl.create(:employee) }

    describe "with wrong user" do
      let(:another_employee) { FactoryGirl.create(:employee, email: "other@example.com") }
      before { sign_in_by_controller(employee) }

      it "should redirect to root" do
        get :edit, id: another_employee
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT 'update'" do
    let(:employee) { FactoryGirl.create(:employee) }

    describe "with wrong user" do
      let(:another_employee) { FactoryGirl.create(:employee, email: "other@example.com") }
      before { sign_in_by_controller(employee) }

      it "should redirect to root" do
        put :update, id: another_employee, employee: another_employee
        response.should redirect_to(root_path)
      end
    end
  end
end
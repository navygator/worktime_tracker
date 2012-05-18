require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "user profile" do
    let(:employee) { FactoryGirl.create(:employee) }
    before { visit employee_path(employee) }

    it { should have_selector('h1', text: employee.last_name) }
    it { should have_selector('title', text: employee.last_name) }
  end

  describe "creation employee" do
    before { visit new_employee_path }
    let(:submit) { "Create" }

    describe "with invalid information" do
      it "should not create employee" do
        expect { click_button submit }.to_not change(Employee, :count)
      end

      it "should have error messages" do
        click_button submit
        page.should have_selector("div#error_explanation")
      end
    end

    describe "with valid information" do
      before do
        fill_in :first_name,    with: "John"
        fill_in :middle_name,   with: "Michael"
        fill_in "Last name",    with: "First"
        fill_in "Email",        with: "joe.first@example.com"
        fill_in "Email",        with: "joe.first@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create new employee" do
        expect { click_button submit }.to change(Employee, :count).by(1)
      end

      it "should have success message" do
        click_button submit
        page.should have_selector("div.alert-success", text: 'successfull')
      end
    end
  end
end

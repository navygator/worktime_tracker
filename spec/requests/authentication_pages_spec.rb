require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "sign in" do
    let(:submit) { "Sign in" }
    before { visit signin_path }

    it { should have_selector("h1", text: "Sign in") }
    it { should have_selector("title", text: "Sign in")}

    describe "with invalid credentials" do
      before { click_button submit }

      it { should have_selector("h1", text: "Sign in") }
      it { should have_selector("div.alert.alert-error", text: "Invalid")}

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid credentials" do
      let(:employee) { FactoryGirl.create(:employee) }
      before do
        sign_in employee
      end

      it { should have_selector("title", text: employee.short_name) }
      it { should have_link("Profile", href: employee_path(employee)) }
      it { should have_link("Settings", href: edit_employee_path(employee)) }
      it { should have_link("Sign out", href: signout_path) }
      it { should_not have_link("Sign in", href: signin_path) }

      describe "followed by sign out" do
        before { click_link "Sign out" }

        it { should_not have_link("Sign out", href: signout_path) }
        it { should have_link("Sign in", href: signin_path) }
      end
    end
  end

  describe "authorization" do
    let(:employee) { FactoryGirl.create(:employee) }

    describe "for non signed users" do
      describe "visiting edit page" do
        before { visit edit_employee_path(employee) }

        it { should have_selector("h1", text: "Sign in")}
      end

      describe "submitting to update action" do
        before { put employee_path(employee) }

        specify { response.should redirect_to signin_path }
      end

      describe "accessing users index" do
        before { visit employees_path }

        it { should have_selector("title", text: "Sign in") }
      end

      describe "when attempting to visit edit page" do
        before do
          visit edit_employee_path(employee)
          #fill_in "Email",    with: employee.email
          #fill_in "Password", with: employee.password
          #click_button "Sign in"
          sign_in employee
        end

        describe "after signin in" do
          it "should render desired original page" do
            page.should have_selector('title', text: 'Edit employee')
          end
        end
      end
    end

    describe "for wrong users" do
      let(:another_employee) { FactoryGirl.create(:employee, email: "other@example.com") }
      before { sign_in employee }

      describe "visiting edit page" do
        before { visit edit_employee_path(another_employee) }

        it { should_not have_selector('title', text: full_title('Edit employee')) }
        it { should have_selector('title', text: full_title('Home')) }
      end

      describe "submitting to update action" do
        before { put employee_path(another_employee) }

        #it "should have redirected to root_path"
        specify { response.should redirect_to root_path }
      end
    end
  end
end

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
        fill_in "Email",    with: employee.email
        fill_in "Password", with: employee.password
        click_button submit
      end

      it { should have_selector("title", text: employee.short_name) }
      it { should have_link("Profile", href: employee_path(employee)) }
      it { should have_link("Sign out", href: signout_path) }
      it { should_not have_link("Sign in", href: signin_path) }

      describe "followed by sign out" do
        before { click_link "Sign out" }

        it { should_not have_link("Sign out", href: signout_path) }
        it { should have_link("Sign in", href: signin_path) }
      end
    end
  end
end

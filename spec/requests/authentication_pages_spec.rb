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
      it { should have_selector("div.alert.alert-error", text: "invalid")}
    end

    describe "with valid credentials" do
      let(:employee) { FactoryGirl.create(:employee) }
      before do
        fill_in :email,    with: employee.email
        fill_in :password, with: employee.password
        click_button submit
      end

      it { should have_selector("title", text: employee.short_name) }
      it { should have_link("Profile", href: employee_path(employee)) }
      it { should have_link("Sign out", href: signout_path) }
      it { should have_not_link("Sign in", href: signin_path) }
    end
  end
end

require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "sign in" do
    let(:submit) { "Sign in" }
    before { visit signin_path }

    it { should have_selector("h1", text: "Sign in") }
    it { should have_selector("title", text: "Sign in")}
    it { should_not have_link("Profile") }
    it { should_not have_link("Settings") }

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
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector("title", text: user.short_name) }
      it { should have_link("Users",    href: users_path) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Settings", href: edit_user_path(user)) }
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
    let(:user) { FactoryGirl.create(:user) }

    describe "for non signed users" do
      describe "visiting edit page" do
        before { visit edit_user_path(user) }

        it { should have_selector("h1", text: "Sign in")}
      end

      describe "submitting to update action" do
        before { put user_path(user) }

        specify { response.should redirect_to signin_path }
      end

      describe "accessing users index" do
        before { visit users_path }

        it { should have_selector("title", text: "Sign in") }
      end

      describe "when attempting to visit edit page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signin in" do
          it "should render desired original page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end
    end

    describe "for wrong users" do
      let(:another_user) { FactoryGirl.create(:user, email: "other@example.com") }
      before { sign_in user }

      describe "visiting edit page" do
        before { visit edit_user_path(another_user) }

        it { should_not have_selector('title', text: full_title('Edit user')) }
        it { should have_selector('title', text: full_title('Home')) }
      end

      describe "submitting to update action" do
        before { put user_path(another_user) }
        specify { response.should redirect_to root_path }
      end
    end
  end

  describe "as non-admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }

    before { sign_in non_admin }

    describe "submitting delete request to User#destroy action" do
      before { delete user_path(user) }
      specify { response.should redirect_to(root_path) }
    end
  end

  describe "for signed in users" do
    before { sign_in FactoryGirl.create(:user) }

    describe "visiting new action" do
      before { get new_user_path }
      specify { response.should redirect_to(root_path) }
    end

    describe "submitting post request to User#create action" do
      let(:new_user) { { first_name: "John",
                             last_name: "First",
                             email: "new@example.com",
                             password: "foobar",
                             password_confirmation: "foobar" } }
      before { post users_path({ user: new_user }) }
      specify { response.should redirect_to(root_path) }
    end
  end
end

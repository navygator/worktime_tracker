require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "user profile" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:item) { user.work_items.create!(description: "Overwork for test",
                                          type_id: 1,
                                          start_at: Time.now,
                                          end_at: 1.hours.from_now )}
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.last_name) }
    it { should have_selector('title', text: user.last_name) }

    describe "view" do
      it { should have_selector("li", text: "Overwork") }
    end

    describe "edit" do
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it { should have_selector("h1", text: "Update your profile") }
        it { should have_selector("title", text: "Edit user") }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end

      describe "with valid information" do
        let(:new_fname) { "Jack" }
        let(:new_mname) { "Allan" }
        let(:new_lname) { "Smith" }
        let(:new_email) { "jack.smith@example.com" }
        before do
          fill_in "First name",   with: new_fname
          fill_in "Middle name",  with: new_mname
          fill_in "Last name",    with: new_lname
          fill_in "Email",        with: new_email
          fill_in "Password",     with: user.password
          fill_in "Confirmation", with: user.password
          click_button "Save changes"
        end

        it { should have_selector("div.alert.alert-success", text: 'successfully') }
        it { should have_selector("title", text: "#{new_lname} #{new_fname}") }
        it { should have_selector("h1", text: "#{new_lname} #{new_fname} #{new_mname}") }

        specify { user.reload.first_name.should == new_fname }
        specify { user.reload.last_name.should == new_lname }
      end
    end
  end

  describe "creation user" do
    before { visit new_user_path }
    let(:submit) { "Create" }

    describe "with invalid information" do
      it "should not create user" do
        expect { click_button submit }.to_not change(User, :count)
      end

      it "should have error messages" do
        click_button submit
        page.should have_selector("div#error_explanation")
      end
    end

    describe "with valid information" do
      before do
        fill_in "First name",   with: "John"
        fill_in "Middle name",  with: "Michael"
        fill_in "Last name",    with: "First"
        fill_in "Email",        with: "joe.first@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after create" do
        before { click_button submit }
        let(:user) { User.find_by_email("joe.first@example.com") }

        it { should have_selector("title", text: user.short_name) }

        it "should have success message" do
          page.should have_selector("div.alert.alert-success", text: 'successfully')
        end
      end
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:all) do
      30.times { FactoryGirl.create(:user) }
      User.last.toggle!(:approver)
    end
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector("title", text: "All users") }
    it { should have_selector("h1", text: "All users") }
    it { should_not have_link("delete") }
    it { should_not have_selector("#approver") }
    it { should_not have_selector("edit") }

    describe "pagination" do
      it { should have_selector("div.pagination")}

      it "should list each users" do
        User.paginate(page: 1).each do |user|
          page.should have_selector("li", text: user.short_name)
        end
      end
    end

    describe "for admin users" do
      let(:admin) { FactoryGirl.create(:admin) }

      before do
        sign_in admin
        visit users_path
      end

      describe "delete links" do

        it { should have_link("delete", href: user_path(User.first)) }
        it { should_not have_link("delete", href: user_path(admin)) }

        it "should be able to delete another user" do
          expect { click_link("delete") }.to change(User, :count).by(-1)
        end
      end

      describe "approvers info" do
        it { should have_selector("div.user-info", text: "(Approver)") }
      end

      describe "edit links" do
        it { should have_link("edit", href: edit_user_path(User.first)) }
      end
    end
  end
end

require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "employee profile" do
    let(:employee) { FactoryGirl.create(:employee) }
    before { visit employee_path(employee) }

    it { should have_selector('h1', text: employee.last_name) }
    it { should have_selector('title', text: employee.last_name) }

    describe "edit" do
      before do
        sign_in employee
        visit edit_employee_path(employee)
      end

      describe "page" do
        it { should have_selector("h1", text: "Update your profile") }
        it { should have_selector("title", text: "Edit employee") }
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
          fill_in "Password",     with: employee.password
          fill_in "Confirmation", with: employee.password
          click_button "Save changes"
        end

        it { should have_selector("div.alert.alert-success", text: 'successfully') }
        it { should have_selector("title", text: "#{new_lname} #{new_fname}") }
        it { should have_selector("h1", text: "#{new_lname} #{new_fname} #{new_mname}") }

        specify { employee.reload.first_name.should == new_fname }
        specify { employee.reload.last_name.should == new_lname }
      end
    end
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
        fill_in "First name",   with: "John"
        fill_in "Middle name",  with: "Michael"
        fill_in "Last name",    with: "First"
        fill_in "Email",        with: "joe.first@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create new employee" do
        expect { click_button submit }.to change(Employee, :count).by(1)
      end

      describe "after create" do
        before { click_button submit }
        let(:employee) { Employee.find_by_email("joe.first@example.com") }

        it { should have_selector("title", text: employee.short_name) }

        it "should have success message" do
          page.should have_selector("div.alert.alert-success", text: 'successfully')
        end
      end
    end
  end

  describe "index" do
    let(:employee) { FactoryGirl.create(:employee) }
    before(:all) { 30.times { FactoryGirl.create(:employee) } }
    after(:all) { Employee.delete_all }

    before(:each) do
      sign_in employee
      visit employees_path
    end

    it { should have_selector("title", text: "All employees") }
    it { should have_selector("h1", text: "All employees") }

    describe "pagination" do
      it { should have_selector("div.pagination")}

      it "should list each employees" do
        Employee.paginate(page: 1).each do |employee|
          page.should have_selector("li", text: employee.short_name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link("delete") }

      describe "for admin users" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit employees_path
        end

        it { should have_link("delete", href: employee_path(Employee.first)) }
        it { should_not have_link("delete", href: employee_path(admin)) }

        it "should be able to delete another employee" do
          expect { click_link("delete") }.to change(Employee, :count).by(-1)
        end
      end
    end
  end
end

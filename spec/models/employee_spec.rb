# == Schema Information
#
# Table name: employees
#
#  id          :integer         not null, primary key
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  email       :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Employee do
  before { @employee = Employee.new(first_name: "First",
                                    last_name: "Employee",
                                    email: "user@example.com",
                                    password: "foobar",
                                    password_confirmation: "foobar")}

  subject { @employee }

  it { should respond_to(:admin) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:middle_name) }
  it { should respond_to(:full_name) }
  it { should respond_to(:short_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to true" do
    before { @employee.toggle!(:admin) }

    it { should be_admin }
  end

  describe "Validations" do
       describe "First Name" do
      it "should be present" do
        @employee.first_name = ""
        @employee.should_not be_valid
      end

      it "should be less than 51 chars long" do
        @employee.first_name = "a" * 51
        @employee.should_not be_valid
      end

      it "should be more than 4 char long" do
        @employee.first_name = "a" * 3
        @employee.should_not be_valid
      end
    end

    describe "Last Name" do
      it "should be present" do
        @employee.last_name = ""
        @employee.should_not be_valid
      end

      it "should be less than 51 chars long" do
        @employee.last_name = "a" * 51
        @employee.should_not be_valid
      end

      it "should be more than 1 char long" do
        @employee.last_name = "a"
        @employee.should_not be_valid
      end
    end

    describe "Email" do
      it "should be present" do
        @employee.email = ""
        @employee.should_not be_valid
      end

      it "should not allow invalid format" do
        addresses = %w[user@foo,com user@foo  user_at_foo.org ex.user@foo. foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |email|
          @employee.email = email
          @employee.should_not be_valid
        end
      end

      it "should be valid format" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |email|
          @employee.email = email
          @employee.should be_valid
        end
      end

      it "should be unique" do
        employee_with_same_email = @employee.dup
        employee_with_same_email.email = @employee.email.upcase
        employee_with_same_email.save
        @employee.should_not be_valid
      end
    end

    describe "Password" do
      describe "when is not present" do
        before { @employee.password = @employee.password_confirmation = " " }
        it { should_not be_valid }
      end

      describe "when doesn't match confirmation" do
        before { @employee.password_confirmation = "mismatch" }
        it { should_not be_valid }
      end

      describe "when confirmation is nil" do
        before { @employee.password_confirmation = nil }
        it { should_not be_valid }
      end
    end
  end

  describe "Authenticate method" do
    before { @employee.save }
    let(:found_employee) { Employee.find_by_email(@employee.email) }

    describe "with valid password" do
      it { should == found_employee.authenticate(@employee.password) }
    end

    describe "" do
      let(:invalid_authenticate) { found_employee.authenticate("invalid") }

      it { should_not == invalid_authenticate }
      specify {invalid_authenticate.should be_false }
    end

    describe "with password too short" do
      before { @employee.password = @employee.password_confirmation = "a" * 5 }
      it { should_not be_valid }
    end
  end

  it "should have short name from last and first names" do
    @employee.short_name.should == "#{@employee.last_name} #{@employee.first_name}"
  end

  it "should have full name from last, first and middle names" do
    @employee.full_name.should == "#{@employee.short_name} #{@employee.middle_name}"
  end

  describe "remember token" do
    before { @employee.save }
    its(:remember_token) { should_not be_blank }
    end
end

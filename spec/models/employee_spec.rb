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
  before { @employee = Employee.new(first_name: "First", last_name: "Employee", email: "user@example.com")}

  subject { @employee }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:middle_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should be_valid }

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
  end
end

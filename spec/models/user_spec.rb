# == Schema Information
#
# Table name: users
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

describe User do
  before { @user = User.new(first_name: "First",
                                    last_name: "User",
                                    email: "user@example.com",
                                    password: "foobar",
                                    password_confirmation: "foobar")}

  subject { @user }

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
  it { should respond_to(:approver) }
  it { should respond_to(:approvers) }
  it { should respond_to(:approving) }
  it { should respond_to(:work_items) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to true" do
    before { @user.toggle!(:admin) }

    it { should be_admin }
  end

  describe "Validations" do
       describe "First Name" do
      it "should be present" do
        @user.first_name = ""
        @user.should_not be_valid
      end

      it "should be less than 51 chars long" do
        @user.first_name = "a" * 51
        @user.should_not be_valid
      end

      it "should be more than 2 char long" do
        @user.first_name = "a"
        @user.should_not be_valid
      end
    end

    describe "Last Name" do
      it "should be present" do
        @user.last_name = ""
        @user.should_not be_valid
      end

      it "should be less than 51 chars long" do
        @user.last_name = "a" * 51
        @user.should_not be_valid
      end

      it "should be more than 1 char long" do
        @user.last_name = "a"
        @user.should_not be_valid
      end
    end

    describe "Email" do
      it "should be present" do
        @user.email = ""
        @user.should_not be_valid
      end

      it "should not allow invalid format" do
        addresses = %w[user@foo,com user@foo  user_at_foo.org ex.user@foo. foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |email|
          @user.email = email
          @user.should_not be_valid
        end
      end

      it "should be valid format" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |email|
          @user.email = email
          @user.should be_valid
        end
      end

      it "should be unique" do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
        @user.should_not be_valid
      end
    end

    describe "Password" do
      describe "when is not present" do
        before { @user.password = @user.password_confirmation = " " }
        it { should_not be_valid }
      end

      describe "when doesn't match confirmation" do
        before { @user.password_confirmation = "mismatch" }
        it { should_not be_valid }
      end

      describe "when confirmation is nil" do
        before { @user.password_confirmation = nil }
        it { should_not be_valid }
      end
    end
  end

  describe "Authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "" do
      let(:invalid_authenticate) { found_user.authenticate("invalid") }

      it { should_not == invalid_authenticate }
      specify {invalid_authenticate.should be_false }
    end

    describe "with password too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should_not be_valid }
    end
  end

  it "should have short name from last and first names" do
    @user.short_name.should == "#{@user.last_name} #{@user.first_name}"
  end

  it "should have full name from last, first and middle names" do
    @user.full_name.should == "#{@user.short_name} #{@user.middle_name}"
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
    end
end

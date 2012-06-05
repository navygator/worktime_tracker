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

class Employee < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :middle_name, :password, :password_confirmation
  has_secure_password

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :first_name, presence: true, length: { in: 4..50 }
  validates :last_name, presence: true, length: { in: 2..50 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  def full_name
    "#{short_name} #{middle_name}"
  end

  def short_name
    "#{last_name} #{first_name}"
  end

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64 if self.remember_token.nil?
  end
end

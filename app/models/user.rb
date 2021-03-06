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

class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :middle_name, :short_name, :password, :password_confirmation
  has_secure_password

  has_many :relations, :foreign_key => :approver_id, :dependent => :destroy
  has_many :revers_relations, :foreign_key => :approved_id,
           :class_name => "Relation", :dependent => :destroy
  has_many :approving, :through => :relations, :source => :approved
  has_many :approvers, :through => :revers_relations, :source => :approver

  has_many :work_items

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :first_name, presence: true, length: { in: 2..50 }
  validates :last_name, presence: true, length: { in: 2..50 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  scope :not_approved_by, lambda { |user| have_not_approver(user) }

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

  def self.have_not_approver(user)
    approving_ids = %(SELECT approved_id FROM relations WHERE approver_id = #{user.id} )
    where("id not in (#{approving_ids}) and id <> ?", user)
  end
end

class Approving < ActiveRecord::Base
  attr_accessible :approved_id

  belongs_to :approver, class_name: "User"
  belongs_to :approved, class_name: "User"

  #validates :approver_id, presence: true
  #validates :approved_id, presence: true
end

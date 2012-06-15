class AddApproverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approver, :boolean
  end
end

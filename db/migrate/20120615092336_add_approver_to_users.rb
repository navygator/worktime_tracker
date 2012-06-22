class AddApproverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approver, :boolean, default: false
  end
end

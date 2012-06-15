class CreateApprovings < ActiveRecord::Migration
  def change
    create_table :approvings do |t|
      t.integer :approver_id
      t.integer :approved_id

      t.timestamps
    end
  end
end

class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :approver_id
      t.integer :approved_id

      t.timestamps
    end
  end
end

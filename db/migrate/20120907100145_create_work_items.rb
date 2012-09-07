class CreateWorkItems < ActiveRecord::Migration
  def change
    create_table :work_items do |t|
      t.integer :user_id
      t.integer :type_id
      t.string :description
      t.date :start_at
      t.date :end_at
      t.string :workflow_state

      t.timestamps
    end
  end
end

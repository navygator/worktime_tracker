class ChangeDatesInWorkitems < ActiveRecord::Migration
  def change
    change_column :work_items, :start_at, :datetime
    change_column :work_items, :end_at, :datetime
  end
end

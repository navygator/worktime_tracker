class AddRememberTokenToEmployee < ActiveRecord::Migration
  def change
    add_column :employees,  :remember_token, :string
    add_index :employees, :remember_token
  end
end

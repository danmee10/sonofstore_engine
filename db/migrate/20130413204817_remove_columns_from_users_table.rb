class RemoveColumnsFromUsersTable < ActiveRecord::Migration
  def change
    remove_column :users, :email
    remove_column :users, :full_name
  end
end

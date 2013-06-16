class AddDefaultValueToPlatformAdminInUsersTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :platform_admin
      t.boolean :platform_admin, :default => true
    end
  end
end

class AddShippingAddressToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_address_id, :integer
    add_index :orders, :shipping_address_id
  end
end

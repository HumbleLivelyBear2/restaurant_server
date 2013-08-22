class AddDeviceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device_id, :string
    add_index :users, :device_id
  end
end

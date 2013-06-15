class AddUserDeviceToken < ActiveRecord::Migration
  def up
  	add_column	:users, :ios_device_token, :string, :unique => true
  	add_index	:users, :ios_device_token, :unique => true
  end

  def down
  	remove_column	:users, :ios_device_token
  end
end

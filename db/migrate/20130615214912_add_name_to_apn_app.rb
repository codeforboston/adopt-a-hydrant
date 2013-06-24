class AddNameToApnApp < ActiveRecord::Migration
  def change
  	add_column	:apn_apps, :name, :string, :unique => true
  	add_index	:apn_apps, :name, :unique => true
  end
end

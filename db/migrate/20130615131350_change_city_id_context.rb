class ChangeCityIdContext < ActiveRecord::Migration
  def up
  	remove_index	:things, :city_id
  	add_index	:things, :city_id, :unique => false
  end

  def down
  	remove_index	:things, :city_id
  	add_index	:things, :city_id, :unique => true
  end
end

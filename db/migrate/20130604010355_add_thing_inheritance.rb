class AddThingInheritance < ActiveRecord::Migration
  def up
  	add_column	:things, :type, :string
  	Thing.find_each do |thing|
  		thing.type = 'Hydrant'
  		thing.save!
  	end
  end

  def down
  	remove_column	:things, :type
  end
end

class RemoveUniqueEmailConstraint < ActiveRecord::Migration
  def up
  	remove_index	:users, :email
  	add_index	:users, [:provider, :uid]
  end

  def down
  	remove_index	:users, [:provider, :uid]
  	add_index	:users, :email, :unique => true
  end
end

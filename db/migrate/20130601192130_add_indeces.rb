class AddIndeces < ActiveRecord::Migration
  def up
  	add_index :events, [:user_id, :thing_id]
  end

  def down
  	remove_index :events, [:user_id, :thing_id]
  end
end

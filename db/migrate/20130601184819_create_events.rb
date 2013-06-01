class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.integer :user_id
    	t.integer :thing_id

      t.timestamps
    end
  end
end

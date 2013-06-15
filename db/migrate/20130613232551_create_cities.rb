class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string  :city_name
      t.string  :state_abbreviation
      t.string  :state_name
      t.decimal :lat, null: false, precision: 16, scale: 14
      t.decimal :lng, null: false, precision: 17, scale: 14

      t.timestamps
    end
  end
end

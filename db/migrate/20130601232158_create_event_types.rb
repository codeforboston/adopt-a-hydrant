class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string  :i18n_key
      t.string  :action, :unique => true
      t.timestamps
    end

    add_column  :events, :event_type_id, :integer
    add_index :event_types, :action

    EventType.create!(:i18n_key => "constants.shoveled", :action => "shoveled")
    EventType.create!(:i18n_key => "constants.abandoned", :action => "abandoned")
    EventType.create!(:i18n_key => "constants.adopted", :action => "adopted")
  end
end

class Event < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :thing
  belongs_to :event_type
end

class Thing < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Geokit::Geocoders
  validates_uniqueness_of :city_id, allow_nil: true
  validates_presence_of :lat, :lng
  belongs_to :user
  has_many :reminders
  has_many :events

  def self.find_closest(lat, lng, limit=10)
    query = <<-SQL
      SELECT *, (3959 * ACOS(COS(RADIANS(?)) * COS(RADIANS(lat)) * COS(RADIANS(lng) - RADIANS(?)) + SIN(RADIANS(?)) * SIN(RADIANS(lat)))) AS distance
      FROM things
      ORDER BY distance
      LIMIT ?
      SQL
    find_by_sql([query, lat.to_f, lng.to_f, lat.to_f, limit.to_i])
  end

  # Return all things that need to be adopted
  def self.all_unadopted
    where("user_id IS NULL")
  end

  # Return all things that are currently adopted
  def self.all_adopted
    where("user_id IS NOT NULL")
  end

  # Find things which have had a certain event since a specified time.
  def self.with_event_type(event_type_id, since)
    all(:joins => {:events => :event_type}, :conditions => ["events.event_type_id = ? AND events.created_at < ?", event_type_id, since])
  end

  def reverse_geocode
    @reverse_geocode ||= MultiGeocoder.reverse_geocode([lat, lng])
  end

  def street_number
    reverse_geocode.street_number
  end

  def street_name
    reverse_geocode.street_name
  end

  def street_address
    reverse_geocode.street_address
  end

  def city
    reverse_geocode.city
  end

  def state
    reverse_geocode.state
  end

  def zip
    reverse_geocode.zip
  end

  def country_code
    reverse_geocode.country_code
  end

  def country
    reverse_geocode.country
  end

  def full_address
    reverse_geocode.full_address
  end

  def adopted?
    !user_id.nil?
  end

  def shovel_action_needed?(event,event_type_id,thing,trigger,interval_days)
    Time.now - trigger > interval_days*24.hours && count(:joins => [:events], :conditions => ["events.event_type_id = ? AND events.created_at < ? AND things.id = ?", event_type_id, trigger, self.id])>0
  end

  def color
    if adopted?
      if action_needed?
        color = 'red'
      else
        color = 'green'
      end
    else
      color = 'yellow'
    end
    return color

  def my_thing?(user)
    user.id == current_user.id
  end


end

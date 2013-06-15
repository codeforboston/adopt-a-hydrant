class Thing < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Geokit::Geocoders
  attr_accessible :indicator_and_color, :city_id, :lat, :lng, :name, :user_id, :type
  #validates_uniqueness_of :city_id, allow_nil: true
  validates_presence_of :lat, :lng
  belongs_to :user
  has_many :reminders
  has_many :events
  belongs_to  :city

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
    all(:joins => [:events], :conditions => ["events.event_type_id = ? AND events.created_at < ?", event_type_id, since])
  end

  def reverse_geocode
    @reverse_geocode ||= MultiGeocoder.reverse_geocode([lat, lng])
  end

  # def street_number
  #   reverse_geocode.street_number
  # end

  # def street_name
  #   reverse_geocode.street_name
  # end

  # def street_address
  #   reverse_geocode.street_address
  # end

  # def city
  #   reverse_geocode.city
  # end

  # def state
  #   reverse_geocode.state
  # end

  # def zip
  #   reverse_geocode.zip
  # end

  # def country_code
  #   reverse_geocode.country_code
  # end

  # def country
  #   reverse_geocode.country
  # end

  # def full_address
  #   reverse_geocode.full_address
  # end

  def adopted?
    !user_id.nil?
  end

  # Determine if an event type has happened to this thing within 'hours' of 'trigger'
  # true if at least 1 event of event_type_id took place in the timeframe
  def action_happened?(event_type_id, trigger, hours)
    Thing.count(:joins => [:events], :conditions => ["events.event_type_id = ? AND events.created_at BETWEEN ? and ?", event_type_id, trigger, trigger + (hours).hours]) > 0
  end

  # Indicates the state of this "thing"
  def indicator_and_color(current_user, event_type_id, trigger, hours)
    ic = {:color => 'green', :indicator => 'thing'}
    if adopted?
      if !action_happened?(event_type_id, trigger, hours)
        ic[:color] = 'red'
      end
      ic[:indicator] = 'my_thing' if my_thing?(current_user)
    else
      ic[:color] = 'yellow'
    end
    ic
  end

  def my_thing?(current_user)
    user.id == current_user.id
  end
end

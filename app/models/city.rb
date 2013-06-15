class City < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many	:things

  # Used to pass to APIs like Wunderground
  def underscored_name
  	city_name.gsub(/\s+/,'_')
  end
end

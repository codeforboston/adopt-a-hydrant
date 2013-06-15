require 'ostruct'

weather_hash = {
	'provider' => 'wunderground',
	'api_key' => '',
	'summer_start' => '',
	'summer_end' => ''
}

env_specific_weather = YAML.load_file("#{Rails.root}/config/weather.yml")[Rails.env] if File.exists? "#{Rails.root}/config/weather.yml"
weather_hash.merge! env_specific_weather unless env_specific_weather.nil?

WEATHER_CONFIG = OpenStruct.new(weather_hash)
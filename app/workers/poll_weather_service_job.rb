class PollWeatherServiceJob < BaseJob

	def self.perform
    ws = WeatherProvider.new
    case WEATHER_CONFIG.provider
    when 'wunderground'
      ws = WundergroundWeatherProvider.new
    end

    City.find_each do |city|
      Rails.logger.info("Polling weather service for #{city.city_name}")

      # Any storms imminent?
      storm_expected = ws.storm_approaching?(city.id)

      # Any snowfall expected?
      inches_expected = ws.expected_snowfall(city.id)

      # Has there been significant snowfall in the last 24 hours?
      inches_received = ws.actual_snowfall(city.id)

      Rails.logger.info("Finished weather service poll for #{city.city_name}")
    end

  end
end
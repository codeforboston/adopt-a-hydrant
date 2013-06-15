require 'httparty'

class WundergroundWeatherProvider < WeatherProvider

  def provider_enabled?(city_id)
    super(city_id)
    # Just make a quick assumption that from May - September we won't have snow - or not enough to matter
    now = Date.today
    year = now.year.to_s
    start_date = WEATHER_CONFIG.summer_start.blank? ? Date.parse("#{year}-05-01") : Date.parse(WEATHER_CONFIG.summer_start.gsub('yyyy', year))
    end_date = WEATHER_CONFIG.summer_end.blank? ? Date.parse("#{year}-09-01") : Date.parse(WEATHER_CONFIG.summer_end.gsub('yyyy', year))

    enabled = !(start_date..end_date).include?(now)
    Rails.logger.debug("Weather provider is checking enabled: Start Date = #{start_date}, End Date = #{end_date}")
    Rails.logger.info("The weather provider is #{enabled ? 'enabled' : 'disabled'}")
    enabled
  end

  def storm_approaching?(city_id)
    super(city_id)
    return false unless provider_enabled?(city_id)
  end

  def expected_snowfall(city_id)
    super(city_id)
    return 0 unless provider_enabled?(city_id)
    city = City.find_by_id(city_id)
    return 0 if city.blank?
    url = "http://api.wunderground.com/api/#{WEATHER_CONFIG.api_key}/forecast/q/#{city.state_abbreviation}/#{city.underscored_name}.json"
    Rails.logger.debug("Calling expected_snowfall on city_id #{city_id} with URL #{url}")
    response = HTTParty.get(url)
    Rails.logger.debug("Response from wunderground: #{response['forecast']['simpleforecast']['forecastday'][1]}")
    response['forecast']['simpleforecast']['forecastday'][1]['snow_allday']['in']
  end

  def actual_snowfall(city_id)
    super(city_id)
    return 0 unless provider_enabled?(city_id)
  end

  def winter_weather_advisory?(city_id)
    super(city_id)
    return false unless provider_enabled?(city_id)
    city = City.find_by_id(city_id)
    return false if city.blank?
    url = "http://api.wunderground.com/api/#{WEATHER_CONFIG.api_key}/alerts/q/#{city.state_abbreviation}/#{city.underscored_name}.json"
    Rails.logger.debug("Calling winter_weather_advisory on city_id #{city_id} with URL #{url}")
    response = HTTParty.get(url)
    alerts = response['alerts']
    alerts.each do |alert|
      return true if alert['type'] == 'WIN'
    end
    false
  end

end
class WeatherProvider

  # Determine whether the provider should even be enabled. This can be used to disable this
  # feature completely, or dynamically determine when we should even bother to check whether
  # storms are coming. No need to check for snow in July, right?
  def provider_enabled?(city_id)
    return false
  end

  # Determine from the weather service whether a winter storm is approaching. Returns true
  # if snow is forecast for the next 24 hours.
  def storm_approaching?(city_id)
    raise "You must supply an api key to use the weather provider" if WEATHER_CONFIG.api_key.blank?
    return false unless provider_enabled?(city_id)
  end

  # Returns the amount of snow the weather service expects in the next 24 hours
  def expected_snowfall(city_id)
    raise "You must supply an api key to use the weather provider" if WEATHER_CONFIG.api_key.blank?
    return 0 unless provider_enabled?(city_id)
  end

  # Returns the actual snowfall amounts in the last 24 hours
  def actual_snowfall(city_id)
    raise "You must supply an api key to use the weather provider" if WEATHER_CONFIG.api_key.blank?
    return 0 unless provider_enabled?(city_id)
  end

  # Return true if a city is currently under a Winter Weather Advisory
  def winter_weather_advisory?(city_id)
    raise "You must supply an api key to use the weather provider" if WEATHER_CONFIG.api_key.blank?
    return false unless provider_enabled?(city_id)
  end
end
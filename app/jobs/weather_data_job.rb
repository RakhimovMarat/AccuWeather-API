require 'httparty'

class WeatherDataJob < ApplicationJob
  queue_as :default

  def perform
    accuweather_api_key = 'aPmXW3zSMgsz4K84mkY8fVRokC5xkAZY'
    #accuweather_api_key = '0PJDztP9Dy8StHh0HjGGsC3BMFNiBfbq'
    city_key = '295954'

    response = HTTParty.get("http://dataservice.accuweather.com/currentconditions/v1/#{city_key}?apikey=#{accuweather_api_key}")
    temperature = response.parsed_response[0]['Temperature']['Metric']['Value']
    timestamp = Time.now

    WeatherCondition.create(temperature: temperature, timestamp: timestamp)
  end
end

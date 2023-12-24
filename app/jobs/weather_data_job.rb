class WeatherDataJob < ApplicationJob
  queue_as :default

  def perform
    accuweather_api_key = 'aPmXW3zSMgsz4K84mkY8fVRokC5xkAZY'
    city_key = '295954'

    response_current_weather = HTTParty.get(
        "http://dataservice.accuweather.com/currentconditions/v1/#{city_key}?apikey=#{accuweather_api_key}&language=en"
    )
    current_data = JSON.parse(response.body).first

    return unless current_data

    temperature = current_data.dig('Temperature', 'Metric', 'Value')
    timestamp = Time.parse(current_data['LocalObservationDateTime']).to_i

    WeatherCondition.create(temperature: temperature, timestamp: timestamp)
  end
end

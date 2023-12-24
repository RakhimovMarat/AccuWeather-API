require 'grape'
require 'httparty'

module Weather
  class Temperature < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
      def error_500
        error!('Не удалось получить данные о температуре', 500)
      end

      def error_404
        error!('Нет данных по текущему запросу', 404)
      end
    end

    resource :weather do

      accuweather_api_key = 'aPmXW3zSMgsz4K84mkY8fVRokC5xkAZY'
      city_key = '295954'
      response_current_weather = HTTParty.get(
        "http://dataservice.accuweather.com/currentconditions/v1/#{city_key}?apikey=#{accuweather_api_key}&language=en"
      )
      response_historical_weather = HTTParty.get(
        "http://dataservice.accuweather.com/currentconditions/v1/#{city_key}/historical/24?apikey=#{accuweather_api_key}&language=en"
      )

      desc 'Текущая температура'
      get :current do
        if response_current_weather.code == 200
          current_temperature = response_current_weather.parsed_response[0]['Temperature']['Metric']['Value']

          { temperature: current_temperature }
        else
          error_500
        end
      end

      desc 'Почасовая температура за последние 24 часа'
      get :historical do
        if response_historical_weather.code == 200
          historical_data = JSON.parse(response_historical_weather.body).map do |hour_data|
             {
              timestamp: hour_data['EpochTime'],
              temperature: hour_data['Temperature']['Metric']['Value']
            }
          end
        else
          error_500
        end
      end

      desc 'Максимальная темперетура за 24 часа'
      get 'historical/max' do
        if response_historical_weather.code == 200
          historical_max_data = JSON.parse(response_historical_weather.body).max_by{
                                |hour_data| hour_data['Temperature']['Metric']['Value'] }
          max_temperature = historical_max_data['Temperature']['Metric']['Value']

          { max_temperature: max_temperature }
        else
          error_500
        end
      end

      desc 'Минимальная темперетура за 24 часа'
      get 'historical/min' do
        if response_historical_weather.code == 200
          historical_min_data = JSON.parse(response_historical_weather.body).min_by{
                                |hour_data| hour_data['Temperature']['Metric']['Value'] }
          min_temperature = historical_min_data['Temperature']['Metric']['Value']

          { min_temperature: min_temperature }
        else
          error_500
        end
      end

      desc 'Средняя темперетура за 24 часа'
      get 'historical/avg' do
        if response_historical_weather.code == 200
          historical_avg_data = JSON.parse(response_historical_weather.body)
          total_temperature = historical_avg_data.sum {
                              |hour_data| hour_data['Temperature']['Metric']['Value'] }
          avg_temperature = total_temperature / historical_avg_data.length

          { average_temperature: avg_temperature }
        else
          error_500
        end
      end

      desc 'Температура ближайшая к переданному timestamp'
      params do
        requires :timestamp, type: Integer, desc: 'Unix timestamp'
      end
      get '/weather/by_time' do
        timestamp = params[:timestamp]

        closest_weather_data = WeatherCondition.order('ABS(timestamp - ?)', timestamp).first

        if closest_weather_data.present?
          { temperature: closest_weather_data.temperature, timestamp: closest_weather_data.timestamp }
        else
          error_404
        end
      end
    end

    desc 'Статус бекенда'
    get '/health' do
      { status: 'OK' }
    end

  end
end

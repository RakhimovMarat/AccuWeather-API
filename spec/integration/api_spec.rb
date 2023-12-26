require 'spec_helper'

describe WeatherApi::Temperature do
  include Rack::Test::Methods

  def app
    WeatherApi::Temperature
  end

  describe 'GET /api/v1/weather/current' do
    it 'возвращает текущую температуру' do
      VCR.use_cassette('current_temperature') do
        get '/api/v1/weather/current'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to have_key('temperature')
      end
    end
  end

  describe 'GET /api/v1/weather/historical' do
    it 'возвращает почасовую температуру за последние 24 часа ' do
      VCR.use_cassette('historical_weather') do
        get '/api/v1/weather/historical'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to be_an(Array)
      end
    end
  end

  describe 'GET /api/v1/weather/historical/max' do
    it 'возвращает максимальную темперетуру за 24 часа' do
      VCR.use_cassette('max_weather') do
        get '/api/v1/weather/historical/max'
        expect(last_response.status).to eq(200)

        response_data = JSON.parse(last_response.body)
        expect(response_data).to have_key('max_temperature')
        expect(response_data['max_temperature']).to be_a(Float)
      end
    end
  end

  describe 'GET /api/v1/weather/historical/min' do
    it 'возвращает минимальную темперетуру за 24 часа' do
      VCR.use_cassette('min_weather') do
        get '/api/v1/weather/historical/min'
        expect(last_response.status).to eq(200)

        response_data = JSON.parse(last_response.body)
        expect(response_data).to have_key('min_temperature')
        expect(response_data['min_temperature']).to be_a(Float)
      end
    end
  end

  describe 'GET /api/v1/weather/historical/avg' do
    it 'возвращает среднюю темперетуру за 24 часа' do
      VCR.use_cassette('avg_weather') do
        get '/api/v1/weather/historical/avg'
        expect(last_response.status).to eq(200)

        response_data = JSON.parse(last_response.body)
        expect(response_data).to have_key('average_temperature')
        expect(response_data['average_temperature']).to be_a(Float)
      end
    end
  end

  describe 'GET /api/v1/health' do
    it 'возвращает статус бекенда' do
      get '/api/v1/health'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq('status' => 'OK')
    end
  end

end

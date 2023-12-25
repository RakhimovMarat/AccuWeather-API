Rails.application.routes.draw do
  mount WeatherApi::Temperature => '/'
end

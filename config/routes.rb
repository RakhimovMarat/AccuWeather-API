Rails.application.routes.draw do
  mount WeatherApi::Temperature => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end

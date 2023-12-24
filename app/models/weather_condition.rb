class WeatherCondition < ApplicationRecord
  validates :timestamp, presence: true
  validates :temperature, presence: true
end

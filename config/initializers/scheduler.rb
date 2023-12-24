require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '1h' do
  WeatherDataJob.perform_later
end

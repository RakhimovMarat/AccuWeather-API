require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '1h' do
  timestamp = Time.now.to_i
  WeatherDataJob.perform_later(timestamp)
end

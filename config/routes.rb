Rails.application.routes.draw do
  mount Weather::Temperature => '/'
end

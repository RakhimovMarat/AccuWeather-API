# AccuWeather-API

This application diplays the temperature in Kazan city

## 1. License

All source code is available under the MIT License.

## 2. Used gems

grape
delayed_job_active_record
rufus-scheduler
httparty
grape-swagger
grape-swagger-rails
rspec
vcr

## 3. Start the server

rails s

## 4. Swagger docimentation

http://localhost:3000/swagger

## 5. Endpoints

/weather/current - Текущая температура
/weather/historical - Почасовая температура за последние 24 часа
/weather/historical/max - Максимальная темперетура за 24 часа
/weather/historical/min - Минимальная темперетура за 24 часа
/weather/historical/avg - Средняя темперетура за 24 часа
/weather/by_time - Температура ближайшую к переданному timestamp
/health - Статус бекенда



class CreateWeatherConditions < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_conditions do |t|
      t.datetime :timestamp
      t.float :temperature

      t.timestamps
    end
  end
end

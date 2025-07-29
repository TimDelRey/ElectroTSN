class ReplaceReadingWithDetailedReadingsInIndications < ActiveRecord::Migration[7.1]
  def change
    remove_column :indications, :reading, :float

    add_column :indications, :day_time_reading, :float
    add_column :indications, :night_time_reading, :float
    add_column :indications, :all_day_reading, :float
  end
end

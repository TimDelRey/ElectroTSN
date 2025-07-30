class ReplaceReadingWithDetailedReadingsInIndications < ActiveRecord::Migration[7.1]
  def change
    remove_column :indications, :reading, :float
    remove_column :indications, :tariff_type, :string

    add_column :indications, :day_time_reading, :float
    add_column :indications, :night_time_reading, :float
    add_column :indications, :all_day_reading, :float

    change_column_default :indications, :for_month, -> { 'CURRENT_DATE' }
  end
end

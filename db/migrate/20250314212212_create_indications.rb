class CreateIndications < ActiveRecord::Migration[8.0]
  def change
    create_table :indications do |t|
      t.references :user, null: false, foreign_key: true
      t.float :day_time_reading
      t.float :night_time_reading
      t.float :all_day_reading
      t.date :for_month, null: false, default: -> { 'CURRENT_DATE' }
      t.boolean :is_correct

      t.timestamps
    end
  end
end

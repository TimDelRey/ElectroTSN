class CreateIndications < ActiveRecord::Migration[8.0]
  def change
    create_table :indications do |t|
      t.float :reading, null: false
      t.integer :user_id, null: false
      t.string :tariff_type, null: false
      t.date :for_month, null: false
      t.boolean :is_correct, default: true

      t.timestamps
    end
  end
end

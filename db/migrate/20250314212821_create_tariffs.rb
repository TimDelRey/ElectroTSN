class CreateTariffs < ActiveRecord::Migration[8.0]
  def change
    create_table :tariffs do |t|
      t.string :title, null: false
      t.float :tariff_value, null: false
      t.text :discription

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :name
      t.string :last_name
      t.integer :place_number, null: false
      t.string :users_tariff

      t.timestamps
    end
  end
end

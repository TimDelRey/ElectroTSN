class CreateTariffs < ActiveRecord::Migration[8.0]
  def change
    create_table :tariffs do |t|
      t.string :title, null: false
      t.text :discription
      t.boolean :is_default
      t.float :first_step_value
      t.float :second_step_value
      t.float :third_step_value

      t.timestamps
    end
  end
end

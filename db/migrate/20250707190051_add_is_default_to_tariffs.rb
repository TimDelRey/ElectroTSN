class AddIsDefaultToTariffs < ActiveRecord::Migration[8.0]
  def change
    add_column :tariffs, :is_default, :boolean

    remove_column :tariffs, :tariff_value, :float

    add_column :tariffs, :first_step_value, :float
    add_column :tariffs, :second_step_value, :float
    add_column :tariffs, :third_step_value, :float
  end
end

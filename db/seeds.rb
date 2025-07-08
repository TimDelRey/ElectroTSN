# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Tariff.destroy_all

# дефолтный одноставочный тариф 2025
all_day_tariff_first_half_of_year, all_day_tariff_second_half_of_year = Tariff.create!([
  {
    title: 'Одноставочный I-полугодие',
    is_default: true,
    first_step_value: 4.49,
    second_step_value: 4.82,
    third_step_value: 8.28,
    discription: 'ООО "Севэнергосбыт". С учётом НДС 20% (Приказ Управления по тарифам г. Севастополя от 09.12.2024 г. № 185-УТ)'
  },
  {
    title: 'Одноставочный II-полугодие',
    is_default: true,
    first_step_value: 5.05,
    second_step_value: 5.47,
    third_step_value: 9.4,
    discription: 'ООО "Севэнергосбыт". С учётом НДС 20% (Приказ Управления по тарифам г. Севастополя от 09.12.2024 г. № 185-УТ)'
  }
])

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Indication.destroy_all
Tariff.destroy_all
User.destroy_all

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

user1, user2 = User.create!([
  {
    email: 'mono@example.com',
    password: '123456',
    password_confirmation: '123456',
    first_name: 'Первый',
    name: 'Перваш',
    last_name: 'Первович',
    place_number: 101,
    tariff: 'Однотарифный'
  },
  {
    email: 'duo@example.com',
    password: '123456',
    password_confirmation: '123456',
    first_name: 'Второй',
    name: 'Вториш',
    last_name: 'Вторович',
    place_number: 102,
    tariff: 'Двухтарифный'
  }
])

indication1, indication2, indication3, indication4 = Indication.create!([
  {
    all_day_reading: 10,
    for_month: Date.new(2024, 1, 25),
    user: user1
  },
  {
    all_day_reading: 20,
    for_month: Date.new(2024, 2, 25),
    user: user1
  },
  {
    day_time_reading: 10,
    night_time_reading: 10,
    for_month: Date.new(2024, 1, 25),
    user: user2
  },
  {
    day_time_reading: 20,
    night_time_reading: 20,
    for_month: Date.new(2024, 2, 25),
    user: user2
  }
])

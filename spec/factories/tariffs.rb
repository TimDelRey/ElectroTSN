# == Schema Information
#
# Table name: tariffs
#
#  id           :bigint           not null, primary key
#  discription  :text
#  tariff_value :float            not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :tariff do
    title { 'Однотарифный' }
    tariff_value { 1.5 }
    discription { 'some discription about tariffs in Sevastopol' }
  end
end

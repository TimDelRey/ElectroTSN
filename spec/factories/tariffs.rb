# == Schema Information
#
# Table name: tariffs
#
#  id                :bigint           not null, primary key
#  discription       :text
#  first_step_value  :float
#  is_default        :boolean
#  second_step_value :float
#  third_step_value  :float
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :tariff do
    title { 'Basic' }
    first_step_value { 1.5 }
    second_step_value { 2.5 }
    third_step_value { 3.5 }
    is_default { true }
    discription { 'some discription about tariffs in Sevastopol' }
  end
end

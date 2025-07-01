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
    title { "MyString" }
    tariff_value { 1.5 }
    discription { "MyText" }
  end
end

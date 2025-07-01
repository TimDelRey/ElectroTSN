# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  first_name   :string           not null
#  last_name    :string
#  name         :string
#  place_number :integer          not null
#  users_tariff :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :user do
    first_name { "MyString" }
    name { "MyString" }
    last_name { "MyString" }
    place_number { 1 }
    users_tariff { "MyString" }
  end
end

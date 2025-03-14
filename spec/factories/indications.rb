FactoryBot.define do
  factory :indication do
    reading { 1.5 }
    user_id { 1 }
    tariff_type { "MyString" }
  end
end

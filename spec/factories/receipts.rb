FactoryBot.define do
  factory :receipt do
    user_id { 1 }
    signed { false }
    receipt_instance { "MyText" }
  end
end

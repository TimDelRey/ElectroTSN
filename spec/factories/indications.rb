# == Schema Information
#
# Table name: indications
#
#  id          :bigint           not null, primary key
#  for_month   :date             not null
#  is_correct  :boolean          default(TRUE)
#  reading     :float            not null
#  tariff_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
FactoryBot.define do
  factory :indication do
    reading { 1.5 }
    user_id { 1 }
    tariff_type { "T1" }
  end
end

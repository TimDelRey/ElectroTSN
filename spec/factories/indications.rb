# == Schema Information
#
# Table name: indications
#
#  id                 :bigint           not null, primary key
#  all_day_reading    :float
#  day_time_reading   :float
#  for_month          :date             not null
#  is_correct         :boolean          default(TRUE)
#  night_time_reading :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer          not null
#
FactoryBot.define do
  factory :indication do
    reading { 1.5 }
    user_id { 1 }
    tariff_type { "T1" }
  end
end

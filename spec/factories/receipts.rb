# == Schema Information
#
# Table name: receipts
#
#  id         :bigint           not null, primary key
#  for_month  :date
#  signed     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
FactoryBot.define do
  factory :receipt do
    user_id { 1 }
    signed { false }
    receipt_instance { "csv-url to s3 must be here" }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string
#  name                   :string
#  place_number           :integer          not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  users_tariff           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    first_name     { 'Иванов' }
    name           { 'Иван' }
    last_name      { 'Иванович' }
    place_number   { rand(1..100) }
    users_tariff   { 'двутариaный'}
    email          { 'test@test.test' }
    password       { '123456' }
    password_confirmation { '123456' }
  end
end

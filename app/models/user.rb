# frozen_string_literal: true

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
#  phone_number           :integer
#  place_number           :integer          not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tariff                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :indications
  has_many :receipts

  validates :first_name, presence: true
  validates :place_number, presence: true

  MONO_TARIFFS = [
    'моно', 'mono', 'однотарифный', 'solo', 'соло', 'одноставочный'
  ].freeze

  def tariff_mono?
    MONO_TARIFFS.include?(tariff.to_s.downcase)
  end

  def full_name
    [first_name, name, last_name].compact.join(' ')
  end
end

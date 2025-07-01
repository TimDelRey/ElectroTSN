# frozen_string_literal: true

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
class User < ApplicationRecord
    has_many :indications
    has_many :receipts
end

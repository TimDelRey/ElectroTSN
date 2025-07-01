# frozen_string_literal: true

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
class Tariff < ApplicationRecord
    has_many :indications
end

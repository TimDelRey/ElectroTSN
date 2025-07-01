# frozen_string_literal: true

# == Schema Information
#
# Table name: indications
#
#  id          :bigint           not null, primary key
#  reading     :float            not null
#  tariff_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
class Indication < ApplicationRecord
    belongs_to :user
    belongs_to :tariff
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: tariffs
#
#  id                :bigint           not null, primary key
#  discription       :text
#  first_step_value  :float
#  is_default        :boolean
#  second_step_value :float
#  third_step_value  :float
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Tariff < ApplicationRecord
  scope :default_tariff, -> { where(is_default: true) }

  validate :only_one_default_tariff

  private

  def only_one_default_tariff
    existing_default = Tariff.where(title: title, is_default: true).where.not(id: id)
    if existing_default.exists?
      errors.add(:is_default, "Можно выбрать только один дефолтный тариф для '#{title}'")
    end
  end
end

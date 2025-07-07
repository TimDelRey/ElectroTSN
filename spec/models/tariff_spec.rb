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
require 'rails_helper'

RSpec.describe Tariff, type: :model do
  let! (:tariff) { create(:tariff) }

  context 'when creating a new valid tariff' do
    it 'tariff is created' do
      expect(tariff).to be_valid
    end
  end

  context 'when creating a new tariff with same title' do
    it 'does not allow duplicate default tariffs with same title' do
      tariff = Tariff.new(title: 'Basic')
      expect(tariff).not_to be_valid
      expect(tariff.errors[:is_default]).to include("можно выбрать только один дефолтный тариф для 'Basic'")
    end
  end
end

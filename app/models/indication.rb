# frozen_string_literal: true

class Indication < ApplicationRecord
    belongs_to :user
    belongs_to :tariff
end

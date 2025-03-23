# frozen_string_literal: true

class Receipt < ApplicationRecord
    has_many :indications
end

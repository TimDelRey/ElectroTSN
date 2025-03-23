# frozen_string_literal: true

class User < ApplicationRecord
    has_many :indications
    has_many :receipts
end

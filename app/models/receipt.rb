# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id               :bigint           not null, primary key
#  receipt_instance :text
#  signed           :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer          not null
#
class Receipt < ApplicationRecord
    belongs_to :user
    has_one_attached :xls_file
end

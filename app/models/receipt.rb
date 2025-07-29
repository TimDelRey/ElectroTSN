# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id         :bigint           not null, primary key
#  for_month  :date
#  signed     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
class Receipt < ApplicationRecord
  belongs_to :user
  has_one_attached :xls_file, dependent: :purge_later

  scope :signed_receipts_for_user, ->(user) { Receipt.where(user: user, signed: true).order(for_month: :desc) }

  validate :only_one_signed_receipt_for_month, on: :create

  private

  def only_one_signed_receipt_for_month
    return unless signed? && for_month.present?

    exists = Receipt.where(user_id: user_id, for_month: for_month.beginning_of_month..for_month.end_of_month, signed: true).exists?

    if exists
      errors.add(:base, 'Уже существует подписанная квитанция за этот месяц')
    end
  end
end

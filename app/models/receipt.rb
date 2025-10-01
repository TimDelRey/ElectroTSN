# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id         :bigint           not null, primary key
#  for_month  :date
#  signed     :boolean
#  status     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_receipts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Receipt < ApplicationRecord
  belongs_to :user
  has_one_attached :xls_file, dependent: :purge_later

  after_create :attach_placeholder

  enum :status, { empty: 0, processing: 1, calculated: 2, done: 3, failed: 4}, default: :empty

  scope :signed_receipts_for_user, ->(user) { Receipt.where(user: user, signed: true).order(for_month: :desc) }

  validate :only_one_signed_receipt_for_month, on: :create

  CONTENT_TYPE = "application/vnd.ms-excel"

  private

  def attach_placeholder
    return if xls_file.attached?

    xls_file.attach(
      io: StringIO.new(""),
      filename: "receipt-#{for_month}-#{id}.xls",
      content_type: CONTENT_TYPE
    )
  end

  def only_one_signed_receipt_for_month
    return unless signed? && for_month.present?

    exists = Receipt.where(user_id: user_id, for_month: for_month.beginning_of_month..for_month.end_of_month, signed: true).exists?

    if exists
      errors.add(:base, 'Уже существует подписанная квитанция за этот месяц')
    end
  end
end

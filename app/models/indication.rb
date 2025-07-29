# frozen_string_literal: true

# == Schema Information
#
# Table name: indications
#
#  id                 :bigint           not null, primary key
#  all_day_reading    :float
#  day_time_reading   :float
#  for_month          :date             not null
#  is_correct         :boolean          default(TRUE)
#  night_time_reading :float
#  tariff_type        :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer          not null
#
class Indication < ApplicationRecord
  belongs_to :user
  belongs_to :tariff

  scope :actual, ->(user) { Indication.where(user: user, is_correct: true).order(for_month: :desc) }

  validate :one_correct_reeding_per_month

  private

  def one_correct_reeding_per_month
  end
end

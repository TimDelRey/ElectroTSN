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
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_indications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Indication < ApplicationRecord
  belongs_to :user

  scope :actual, ->(user) { Indication.where(user: user, is_correct: true).order(for_month: :desc) }

  validate :correct_reading_of_user_tariff
  validate :one_correct_tariff_per_month
  validate :indication_now_not_less_previous

  private

  def correct_reading_of_user_tariff
    if user.tariff_mono?
      errors.add("Введены показания не по плану #{user.tariff}") if day_time_reading.present? || night_time_reading.present?
    else
      errors.add("Введены показания не по плану #{user.tariff}") if all_day_reading.present?
    end
  end

  def one_correct_tariff_per_month
    existing_correct = Indication.where.not(id: id).where(
      user: user,
      is_correct: true,
      for_month: for_month.beginning_of_month..for_month.end_of_month
    )
    if existing_correct.exists?
      errors.add("Отмените существующие показания за текущий месяц")
    end
  end

  def indication_now_not_less_previous
    previous_month = for_month.prev_month.beginning_of_month
    previous_indication = Indication.where(user: user, is_correct: true, for_month: previous_month).first
    return if previous_indication.nil?

    if user.tariff_mono?
      if all_day_reading.present? && previous_indication.all_day_reading.present? && all_day_reading < previous_indication.all_day_reading
        errors.add("Показания не могут быть меньше показаний предыдущего месяца")
      end
    else
      if day_time_reading.present? && previous_indication.day_time_reading.present? && day_time_reading < previous_indication.day_time_reading
        errors.add("Дневные показания не могут быть меньше показаний предыдущего месяца")
      end

      if night_time_reading.present? && previous_indication.night_time_reading.present? && night_time_reading < previous_indication.night_time_reading
        errors.add("Ночные показания не могут быть меньше показаний предыдущего месяца")
      end
    end
  end
end

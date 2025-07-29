# frozen_string_literal: true

# == Schema Information
#
# Table name: indications
#
#  id                 :bigint           not null, primary key
#  all_day_reading    :float
#  day_time_reading   :float
#  for_month          :date             not null
#  is_correct         :boolean
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

  after_initialize :set_default_for_month, if: :new_record?

  scope :correct, -> { where(is_correct: true) }
  scope :not_confirmed, -> { where(is_correct: nil) }
  scope :incorrect, -> { where(is_correct: false) }
  scope :actual, ->(user) { correct.where(user: user).order(for_month: :desc) }
  scope :for_recent_months, ->(n = 3) {
    where(for_month: n.months.ago.beginning_of_month..Date.today.end_of_month)
  }
  validate :only_one_correct_indication_per_month
  validate :indication_now_should_be_bigger_previous, unless: :skip_previous_check?
  validate :readings_correspond_to_tariff
  validate :nosave_if_readings_empty
  validates :all_day_reading, :day_time_reading, :night_time_reading, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  attr_accessor :skip_previous_check

  private

  def skip_previous_check?
    skip_previous_check == true
  end

  def set_default_for_month
    self.for_month ||= Date.current
  end

  def only_one_correct_indication_per_month
    return if for_month.blank? || for_month == false
    return unless is_correct

    existing_correct = Indication.where.not(id: id).where(
      user: user,
      is_correct: true,
      for_month: for_month.beginning_of_month..for_month.end_of_month
    )
    if existing_correct.exists?
      errors.add(:base, "Отмените существующие показания за текущий месяц")
    end
  end

  def indication_now_should_be_bigger_previous
    return if for_month.blank?

    previous_month_range = for_month.prev_month.beginning_of_month..for_month.prev_month.end_of_month
    previous_indication = Indication.where(user: user, is_correct: true, for_month: previous_month_range).order(for_month: :desc).first
    return if previous_indication.nil?

    if user.tariff_mono?
      if all_day_reading.present? && previous_indication.all_day_reading.present? && all_day_reading < previous_indication.all_day_reading
        errors.add(:base, "Показания не могут быть меньше показаний предыдущего месяца")
      end
    else
      if day_time_reading.present? && previous_indication.day_time_reading.present? && day_time_reading < previous_indication.day_time_reading
        errors.add(:base, "Дневные показания не могут быть меньше показаний предыдущего месяца")
      end

      if night_time_reading.present? && previous_indication.night_time_reading.present? && night_time_reading < previous_indication.night_time_reading
        errors.add(:base, "Ночные показания не могут быть меньше показаний предыдущего месяца")
      end
    end
  end

  def readings_correspond_to_tariff
    if user.tariff_mono?
      errors.add(:base, "Введены показания не по плану #{user.tariff}") if day_time_reading.present? || night_time_reading.present?
    else
      errors.add(:base, "Введены показания не по плану #{user.tariff}") if all_day_reading.present?
    end
  end

  def nosave_if_readings_empty
    if all_day_reading.blank? && day_time_reading.blank? && night_time_reading.blank?
      errors.add(:base, 'Показания не введены')
    end
  end
end

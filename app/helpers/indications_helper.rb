module IndicationsHelper
  def month_name(date)
    return '-' if date.blank?

    I18n.l(date, format: "%B").capitalize
  end

  def month_options
    today = Date.current.beginning_of_month
    (0..11).map do |i|
      month = today - i.months
      [I18n.l(month, format: '%B %Y').capitalize, month]
    end
  end

  def previous_all_day_reading(last_indication)
    return '-' unless last_indication&.all_day_reading.present? && last_indication&.for_month.present?

    "#{month_name(last_indication.for_month)} #{last_indication.all_day_reading}"
  end

  def previous_day_reading(last_indication)
    return '-' unless last_indication&.day_time_reading.present? && last_indication&.for_month.present?

    "#{month_name(last_indication.for_month)} #{last_indication.day_time_reading}"
  end

  def previous_night_reading(last_indication)
    return '-' unless last_indication&.night_time_reading.present? && last_indication&.for_month.present?

    "#{month_name(last_indication.for_month)} #{last_indication.night_time_reading}"
  end
end

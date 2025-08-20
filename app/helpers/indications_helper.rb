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

  def render_indication_value(indication, user)
    if user.tariff_mono?
      indication&.all_day_reading || "-"
    else
      safe_join([
        "#{indication&.day_time_reading || "-"}",
        tag.br,
        "#{indication&.night_time_reading || "-"}"
      ])
    end
  end

  def render_indication_input(user, current_indication)
    if user.tariff_mono?
      number_field_tag "indications[#{user.id}][all_day_reading]",
        current_indication&.all_day_reading,
        step: 0.1,
        placeholder: current_indication&.all_day_reading || 'Сутки'
    else
      safe_join([
        number_field_tag("indications[#{user.id}][day_time_reading]",
          current_indication&.day_time_reading,
          step: 0.1,
          placeholder: current_indication&.day_time_reading || 'День'),
        " / ",
        number_field_tag("indications[#{user.id}][night_time_reading]",
          current_indication&.night_time_reading,
          step: 0.1,
          placeholder: current_indication&.night_time_reading || 'Ночь')
      ])
    end
  end
end

module IndicationService
  module Utils
    module_function

    def person_indications(user, date)
      month_range = date.beginning_of_month..date.end_of_month
      user.indications.where(for_month: month_range)
    end

    def person_correct_indication(user, date)
      person_indications(user, date).correct.first
    end

    def indications_for_current_month(indications)
      if indications.any? { |i| zero_reading?(i) }
        before_reset = indication_before_reset(indications)
        current = indications.where(is_correct: true).order(id: :desc).first
        [before_reset, current]
      else
        [indications.where(is_correct: true).order(id: :desc).first]
      end
    end

    def indication_before_reset(indications)
      zero_indication = indications.find { |i| zero_reading?(i) }
      return unless zero_indication

      indications
        .where("created_at < ?", zero_indication.created_at)
        .order(created_at: :desc)
        .first
    end

    def zero_reading?(indication)
      (
        indication.all_day_reading&.zero? ||
        indication.day_time_reading&.zero? ||
        indication.night_time_reading&.zero?
      ) && !indication.is_correct
    end
  end
end

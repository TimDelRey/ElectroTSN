module IndicationService
  class ShowCollectiveMonth
    include Service

    def call
      result = {}

      User.includes(:indications).find_each do |user|
        indications = user.indications.for_recent_months(1).order(:for_month, :id)
        previous = indication_previous_month(indications)
        current_set = indications_for_current_month(indications)

        result[user.id] = [previous, *current_set]
      end

      result
    end

    private

    def indication_previous_month(indications)
      indications.where(
        for_month: Date.today.prev_month.beginning_of_month..Date.today.prev_month.end_of_month
      ).order(id: :desc).first
    end

    def indications_for_current_month(indications)
      month_scope = indications.where(for_month: Date.today.beginning_of_month..Date.today.end_of_month)

      if month_scope.any? { |i| zero_reading?(i) }
        before_reset = indication_before_reset(month_scope)
        current = month_scope.order(id: :desc).first
        [before_reset, current]
      else
        [month_scope.order(id: :desc).first]
      end
    end

    def indication_before_reset(month_scope)
      zero_indication = month_scope.find { |i| zero_reading?(i) }
      return unless zero_indication

      Indication.where(id: zero_indication.id - 1).first
    end

    def zero_reading?(indication)
      indication.all_day_reading.to_f.zero? || indication.day_time_reading.to_f.zero? || indication.night_time_reading.to_f.zero?
    end
  end
end

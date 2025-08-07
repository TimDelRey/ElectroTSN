module IndicationService
  class ShowCollectiveMonth
    include Service

    def call
      @indications = {}

      User.includes(:indications).find_each do |user|
        recent_indications = user.indications.for_recent_months(1)

        has_reset = recent_indications.any? do |indication|
          if user.tariff_mono?
            indication.all_day_reading.to_f.zero?
          else
            indication.day_time_reading.to_f.zero? || indication.night_time_reading.to_f.zero?
          end
        end

        has_reset ? reset_indication(user) : normal_indication(user)
      end

      @indications
    end

    private

    def normal_indication(user)
      new_recent = user.indications.correct.for_recent_months(1)
      return if recent.blank?

      @indications[user.id] = recent.map { |i| serialize_indication(i) }
    end

    def reset_indication(user)
      new_recent = user.indications.correct.for_recent_months(1)
      return if new_recent.blank?

      if user.tariff_mono?
        last_before_reset = user.indications
          .where(is_correct: false)
          .for_recent_months(1)
          .order(all_day_reading: :desc)
          .first
      else
        last_before_reset = user.indications
          .where(is_correct: false)
          .for_recent_months(1)
          .order(Arel.sql("GREATEST(COALESCE(day_time_reading, 0), COALESCE(night_time_reading, 0)) DESC"))
          .first
      end

      result = []
      result << serialize_indication(last_before_reset) if last_before_reset.present?
      result.concat(new_recent.map { |i| serialize_indication(i) })

      @indications[user.id] = result
    end

    def serialize_indication(indication)
      indication.as_json(only: [:id, :for_month, :day_time_reading, :night_time_reading, :all_day_reading, :is_correct])
    end
  end
end

module IndicationService
  class ConfirmCurrentMonth
    include Service

    def call
      updated_indications = Indication.not_confirmed.for_recent_months(0).to_a
      updated_indications.each do |i|
        i.update!(is_correct: true) if ready?(i)
      end

      if updated_indications.any?
        success(updated_indications)
      else
        failure("Нет показаний для подтверждения")
      end
    end

    private

    def ready?(i)
      i.all_day_reading.present? || (i.day_time_reading.present? && i.night_time_reading.present?)
    end
  end
end

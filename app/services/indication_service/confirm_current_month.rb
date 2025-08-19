module IndicationService
  class ConfirmCurrentMonth
    include Service

    def call
      updated_indications = Indication.not_confirmed.for_recent_months(0).to_a
      updated_indications.each { |i| i.update!(is_correct: true) }

      if updated_indications.any?
        success(updated_indications)
      else
        failure("Нет показаний для подтверждения")
      end
    end
  end
end

module IndicationService
  class ShowCollectiveMonth
    include Service

    def initialize(date)
      @date = date
    end

    def call
      result = {}

      User.includes(:indications).find_each do |user|
        indications = IndicationService::Utils.person_indications(user, @date)
        previous = IndicationService::Utils.person_correct_indication(user, @date - 1.month)
        current_set = IndicationService::Utils.indications_for_current_month(indications)

        result[user.id] = [previous, *current_set]
      end

      result
    end
  end
end

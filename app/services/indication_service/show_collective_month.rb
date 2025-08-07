module IndicationService
  class ShowCollectiveMonth
    include Service

    def call
      indications = {}

      users = User.includes(:indications)
      users.each do |user|
        recent = user.indications.correct.for_recent_months(1)
        next if recent.blank?

        indications[user.id] = recent.as_json(only: [:id, :for_month, :day_time_reading, :night_time_reading, :all_day_reading])
      end
      indications
    end
  end
end

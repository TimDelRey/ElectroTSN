module IndicationService
  class CreateCollective
    include Service

    def initialize(indications_params)
      @indications_params = indications_params || {}
      @errors = []
    end

    def call
      @indications_params.each do |user_id, indications|
        user = User.find(user_id)

        day = indications[:day_time_reading].presence&.to_f
        night = indications[:night_time_reading].presence&.to_f
        all_day = indications[:all_day_reading].presence&.to_f

        next if all_day.nil? && day.nil? && night.nil?

        indication = user.indications
          .for_recent_months(1)
          .first_or_initialize(for_month: Date.current)

        if user.tariff_mono?
          indication.all_day_reading = all_day
        else
          indication.day_time_reading ||= day
          indication.night_time_reading ||= night

          indication.day_time_reading = day unless day.nil?
          indication.night_time_reading = night unless night.nil?
        end

        unless indication.save
          @errors << "Ошибка для пользователя #{user.first_name}: #{indication.errors.full_messages.to_sentence}"
        end
      end

      self
    end

    attr_reader :errors

    def success?
      errors.empty?
    end
  end
end

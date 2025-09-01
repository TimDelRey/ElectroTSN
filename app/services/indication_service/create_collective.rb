module IndicationService
  class CreateCollective
    include Service

    def initialize(indications_params)
      @indications_params = indications_params || {}
      @errors = []
    end

    def call
      @indications_params.each do |user_id, params|
        user = User.find(user_id)

        day   = params[:day_time_reading].presence
        night = params[:night_time_reading].presence
        all_day   = params[:all_day_reading].presence

        next if day.nil? && night.nil? && all_day.nil?

        indication =
          user.indications.correct.for_recent_months(0).last ||
          user.indications.not_confirmed.for_recent_months(0).last

        if indication.nil?
          indication = user.indications.new(for_month: Date.current)
        end

        if changed?(user, indication, day:, night:, all_day:)
          assign_readings(indication, user, day:, night:, all_day:)

          unless indication.save
            @errors << "Ошибка для пользователя #{user.first_name}: #{indication.errors.full_messages.to_sentence}"
          end
        end
      end

      self
    end

    attr_reader :errors

    def success?
      errors.empty?
    end

    private

    def changed?(user, indication, day:, night:, all_day:)
      if user.tariff_mono?
        indication.all_day_reading.to_s != all_day.to_s
      else
        indication.day_time_reading.to_s != day.to_s ||
          indication.night_time_reading.to_s != night.to_s
      end
    end

    def assign_readings(indication, user, day:, night:, all_day:)
      if user.tariff_mono?
        indication.all_day_reading = all_day
      else
        indication.day_time_reading = day
        indication.night_time_reading = night
      end
    end
  end
end

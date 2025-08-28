module IndicationService
  class ResetParamsBuilder
    include Service

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      if @user.tariff_mono?
        {
          last_indication_old_meter: fetch_or_default(
            :last_indication_old_meter,
            permitted: [:all_day_reading],
            default: last_indication_defaults(["all_day_reading"])
          ).merge(is_correct: false),

          zero_indication_new_meter: { all_day_reading: 0, is_correct: false },

          new_indication_new_meter: fetch_or_default(
            :new_indication_new_meter,
            permitted: [:all_day_reading],
            default: { all_day_reading: 0 }
          ).merge(is_correct: true)
        }
      else
        {
          last_indication_old_meter: fetch_or_default(
            :last_indication_old_meter,
            permitted: [:day_time_reading, :night_time_reading],
            default: last_indication_defaults(["day_time_reading", "night_time_reading"])
          ).merge(is_correct: false),

          zero_indication_new_meter: { day_time_reading: 0, night_time_reading: 0, is_correct: false },

          new_indication_new_meter: fetch_or_default(
            :new_indication_new_meter,
            permitted: [:day_time_reading, :night_time_reading],
            default: { day_time_reading: 0, night_time_reading: 0 }
          ).merge(is_correct: true)
        }
      end
    end

    def fetch_or_default(key, permitted:, default:)
      params_key = @params[key]
      if params_key.blank? || params_key.values.all?(&:blank?)
        default
      else
        @params.require(key).permit(*permitted)
      end
    end

    def last_indication_defaults(fields)
      Indication.actual(@user).first&.attributes&.slice(*fields) || {}
    end
  end
end

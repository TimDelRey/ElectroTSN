module IndicationService
  class CreateReset
    include Service

    def initialize(user, indications_params)
      @user = user
      @params_hash = indications_params
    end

    def call
      @last_indication_old_meter = @user.indications.build(@params_hash[:last_indication_old_meter])
      @zero_indication_new_meter = @user.indications.build(@params_hash[:zero_indication_new_meter].merge(skip_previous_check: true))
      @new_indication_new_meter = @user.indications.build(@params_hash[:new_indication_new_meter].merge(skip_previous_check: true))

      Indication.transaction do
        @last_indication_old_meter.save
        @zero_indication_new_meter.save
        @new_indication_new_meter.save

        success([@last_indication_old_meter, @zero_indication_new_meter, @new_indication_new_meter])
      rescue ActiveRecord::RecordInvalid => e
        failure([e.record.errors.full_messages])
      end

      rescue StandardError => e
      failure([e.message])
    end
  end
end

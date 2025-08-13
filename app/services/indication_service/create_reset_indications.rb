module IndicationService
  class CreateResetIndications
    include Service

    def initialize(user, indications_params)
      @user = user
      @params_hash = indications_params
    end

    def call
      last_indication_old_metter = @user.indications.build(@params_hash[:last_indication_old_metter])
      zero_indication_new_metter = @user.indications.build(@params_hash[:zero_indication_new_metter].merge(skip_previous_check: true))
      new_indication_new_metter = @user.indications.build(@params_hash[:new_indication_new_metter].merge(skip_previous_check: true))

      Indication.transaction do
        return false unless
        last_indication_old_metter.save &&
        zero_indication_new_metter.save &&
        new_indication_new_metter.save
      end
      true
    end
  end
end
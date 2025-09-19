module Api
  module V1
    class TariffsController < Api::V1::BaseController
      def actual
        tariffs = Tariff.default_tariff
        render json: tariffs
      end
    end
  end
end

module Api
  module V1
    class IndicationsController < Api::V1::BaseController
      # примерчик /api/v1/indications/show_person?user_id=5&date=2025-08-14
      def show_person
        user = User.find(params[:user_id])
        date = Date.parse(params[:date])
        indications = IndicationService::Utils.person_indications(user, date)
        indication = IndicationService::Utils.indications_for_current_month(indications)
        render json: indication
      end

      # примерчик /api/v1/indications/show_month_collective?date=2025-08-14
      def show_month_collective
        date = Date.parse(params[:date])
        result = IndicationService::ShowCollectiveMonth.call(date)

        render json: result
      end
    end
  end
end

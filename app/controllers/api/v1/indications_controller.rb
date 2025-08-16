module Api
  module V1
    class IndicationsController < Users::BaseController
      # примерчик /api/v1/indications/show_person?user_id=42&date=2025-08-14
      def show_person
        user = User.find(params[:user_id])
        date = Date.parse(params[:date])
        indication = person_correct_indication(user, date)

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

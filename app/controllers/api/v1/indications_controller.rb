module Api
  module V1
    class ReceiptsController < Users::BaseController
      def show
        @indication = Indication.find(params[:id])
        render json: @indication
      end
    end
  end
end

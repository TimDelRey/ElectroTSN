module Api
  module V1
    class ReceiptsController < Api::V1::BaseController
      def calculated
        receipt = Receipt.find(params[:receipt_id]).update(status: 'calculated')
        render json: receipt
      end

      def complete
        receipt = Receipt.find(params[:receipt_id]).update(status: 'done')
        render json: receipt
      end
    end
  end
end

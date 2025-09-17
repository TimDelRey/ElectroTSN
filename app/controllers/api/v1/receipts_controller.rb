module Api
  module V1
    class ReceiptsController < Api::V1::BaseController
      def complete
        Receipts.find(params[:receipt_id]).update(status: 'done')
      end
    end
  end
end

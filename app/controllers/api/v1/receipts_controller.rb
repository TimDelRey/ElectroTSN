module Api
  module V1
    class ReceiptsController < Api::V1::BaseController
      def create
        @receipt = current_user.receipts.create(receipt_params)

        if @receipt.persisted?
          render json: @receipt, status: :created
        else
          render json: { errors: @receipt.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def receipt_params
        permited = params.permit(:for_month, :receipt_url, :signed)

        permited[:for_month] = Date.today if permited[:for_month].blank?
        permited[:signed] = true if permited[:signed].blank?

        permited
      end
    end
  end
end

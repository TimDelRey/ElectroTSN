module Api
  module V1
    class UsersController < Api::V1::BaseController
      def show
        user = User.find(params[:id])
        user.tariff = "mono" if user.tariff_mono?
        render json: user
      end
    end
  end
end

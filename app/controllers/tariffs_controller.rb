class TariffsController < Users::BaseController
  def index
    # render json: Tariff.default_tariff
    @tariffs = Tariff.default_tariff
  end

  def show
    @tariff = Tariff.find(params[:id])
    # render json: @tariff
  end
end

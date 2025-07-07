class TariffsController < Users::BaseController
  def index
    # render json: Tariff.default_tariff
    @tariffs = Tariff.default_tariff
  end

  def show
  end
end

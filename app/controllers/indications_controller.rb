class IndicationsController < Users::BaseController
  def index
    @user = current_user
    indications = Indication.actual(@user).find(@user.id)
    render json: indications
  end

  def new
  end

  def create
  end

  def collective_per_month
  end

  def new_month_for_collective
  end
end

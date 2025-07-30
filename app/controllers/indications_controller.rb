class IndicationsController < Users::BaseController
  def index
    @user = current_user
    @indications = Indication.actual(@user).where(user: @user)
    # render json: indications
  end

  def new
    @user = current_user
    @last_indication = Indication.actual(@user).first
    @indication = Indication.new
  end

  def create
    @indication = Indication.new(indication_params)
    if @indication.save
      render :index, status: :created
    else
      render json: @indication.errors, status: :unprocessable_entity
    end
  end

  def collective_per_month
  end

  def new_month_for_collective
  end

  private

  def indication_params
    params.require(:indication).permit(:for_month, :all_day_reading, :day_time_reading, :night_time_reading)
  end
end

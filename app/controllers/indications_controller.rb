class IndicationsController < Users::BaseController
  def index
    @user = current_user
    @indications = Indication.actual(@user).where(user: @user)
  end

  def new
    @user = current_user
    @last_indication = Indication.actual(@user).first
    @indication = Indication.new
  end

  def create
    @indication = Indication.new(indication_params)
    @indication.user = current_user

    if @indication.save
      redirect_to indications_path, notice: 'Показания сохранены'
    else
      @user = current_user
      @last_indication = Indication.actual(@user).first
      render :new, status: :unprocessable_entity
    end
  end

  def show_month_of_collective
  end

  def new_month_for_collective
  end

  private

  def indication_params
    params.require(:indication).permit(:for_month, :all_day_reading, :day_time_reading, :night_time_reading)
  end
end

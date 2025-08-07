class IndicationsController < Users::BaseController
  before_action :set_current_user, only: %i[index new create]
  before_action :set_last_indication, only: %i[new create]
  before_action :set_months_param, only: %i[show new_collective create_collective]
  before_action :set_users_with_indications, only: %i[new_collective create_collective]

  def index
    @indications = Indication.actual(@user).where(user: @user)
  end

  def new
    @indication = Indication.new
  end

  def create
    @indication = Indication.new(indication_params)
    @indication.user = current_user

    if @indication.save
      redirect_to indications_path, notice: 'Показания сохранены'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @user_indications = Indication
      .where(user: @user)
      .for_recent_months(@months.to_i)
      .order(user_id: :asc, for_month: :desc)
  end

  def new_collective
    @user_recent_indication = {}
    @users.each do |user|
    recent_indication = user.indications
      .order(for_month: :desc)
      .limit(@months)

      @user_recent_indication[user] = recent_indication
    end
  end

  def create_collective
    result = IndicationService::CreateCollective.call(params[:indications])

    if result.success?
      redirect_to new_collective_indications_path, notice: 'Показания сохранены'
    else
      @user_recent_indication = IndicationService::ShowCollectiveMonth.call
      flash.now[:alert] = result.errors.join(', ')
      render :new_collective, status: :unprocessable_entity
    end
  end


  def calculate
    indication = Indication.find(params[:id])
    render json: indication
  end

  def calculate_collective
    user_month_indications = IndicationService::ShowCollectiveMonth.call

    render json: user_month_indications
  end

  def new_reset_electricity_meter
  end

  def create_reset_electricity_meter
    last_indication_old_metter
    zero_indication_new_metter
    new_indication_new_metter
  end

  private

  def set_current_user
    @user = current_user
  end

  def set_last_indication
    @last_indication = Indication.actual(@user).first
  end

  def set_months_param
    @months = params[:months].presence || 3
  end

  def set_users_with_indications
    @users = User.includes(:indications)
  end

  def indication_params
    params.require(:indication).permit(:for_month, :all_day_reading, :day_time_reading, :night_time_reading)
  end
end

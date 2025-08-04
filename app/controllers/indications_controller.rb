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

  def show
    @user = User.find(params[:id])
    months = params[:months].presence || 3

    @user_indications = Indication
      .where(user: @user)
      .for_recent_months(months.to_i)
      .order(user_id: :asc, for_month: :desc)
  end

  # /indications/new_collective?months=1
  def new_collective
    @users = User.includes(:indications)
    @months = params[:months].presence || 3
    @user_recent_indication = {}

    @users.each do |user|
    recent_indication = user.indications
      .order(for_month: :desc)
      .limit(@months)

      @user_recent_indication[user] = recent_indication
    end
  end

  def create_collective
    def create_collective
      params[:indications]&.each do |user_id, readings|
        user = User.find(user_id)
        indication = user.indications.build(for_month: Date.current.beginning_of_month)

        if user.tariff_mono?
          indication.all_day_reading = readings[:all_day_reading]
        else
          indication.day_time_reading = readings[:day_time_reading]
          indication.night_time_reading = readings[:night_time_reading]
        end

        unless indication.save
          flash[:alert] ||= []
          flash[:alert] << "Ошибка для пользователя #{user.first_name}: #{indication.errors.full_messages.to_sentence}"
        end
      end

      redirect_to new_collective_month_indications_path, notice: "Показания сохранены"
    end

  end

  def reset_electricity_meter
  end

  private

  def indication_params
    params.require(:indication).permit(:for_month, :all_day_reading, :day_time_reading, :night_time_reading)
  end
end

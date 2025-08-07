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
    errors = []

    params[:indications]&.each do |user_id, indications|
      user = User.find(user_id)
      month_start = Date.current.beginning_of_month

      day = indications[:day_time_reading].presence&.to_f
      night = indications[:night_time_reading].presence&.to_f
      all_day = indications[:all_day_reading].presence&.to_f

      next if all_day.nil? && day.nil? && night.nil?

      indication = user.indications.find_or_initialize_by(for_month: month_start)

      if user.tariff_mono?
        indication.all_day_reading = all_day
      else
        indication.day_time_reading ||= day
        indication.night_time_reading ||= night

        indication.day_time_reading = day unless day.nil?
        indication.night_time_reading = night unless night.nil?
      end

      unless indication.save
        errors << "Ошибка для пользователя #{user.first_name}: #{indication.errors.full_messages.to_sentence}"
      end
    end

    if errors.any?
      render :new_collective, status: :unprocessable_entity, notice: errors.join(", ")
    else
      redirect_to new_collective_indications_path, notice: 'Показания сохранены'
    end
  end

  def calculate
    indication = Indication.find(params[:id])
    render json: indication
  end

  def calculate_collective
    user_recent_indication = {}

    users = User.includes(:indications)
    users.each do |user|
      recent = user.indications.correct.where(for_month: Date.current.beginning_of_month..Date.current.end_of_month)
      next if recent.blank?

      user_recent_indication[user.id] = recent.as_json(only: [:id, :for_month, :day_time_reading, :night_time_reading, :all_day_reading])
    end

    render json: user_recent_indication
  end

  def reset_electricity_meter
  end

  private

  def indication_params
    params.require(:indication).permit(:for_month, :all_day_reading, :day_time_reading, :night_time_reading)
  end
end

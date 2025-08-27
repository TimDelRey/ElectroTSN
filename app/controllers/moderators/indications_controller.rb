module Moderators
  class IndicationsController < Users::BaseController
    # def index
    #   @indications = Indication.actual(@user).where(user: @user)
    # end

    def new
      @indication = Indication.new
      @user = User.find(params[:user_id])
      @last_indication = Indication.actual(@user).first
    end

    def create
      @user = User.find(params[:user_id])
      @indication = Indication.new(indications_params)

      if @indication.save
        redirect_to moderators_indication_path(@user), notice: 'Показания сохранены'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # @user = User.find(params[:user_id])
      # @indication = @user.indications.find(params[:id])
      @indication = Indication.find(params[:id])
      @user = @indication.user
      @last_indication = Indication.actual(@user).where.not(id: @indication.id).first
    end

    def update
      # @user = User.find(params[:user_id])
      @indication = Indication.find(params[:id])
      @user = @indication.user

      if @indication.update(indications_params)
        redirect_to moderators_indication_path(@indication, id: @indication.user.id), notice: 'Показания обновлены'
      else
        @last_indication = Indication.actual(@user).where.not(id: @indication.id).first
        render :edit, status: :unprocessable_entity
      end
    end


    def show
      @months = params[:months].presence || 3
      @user = User.find(params[:id])
      @user_indications = Indication
        .where(user: @user)
        .for_recent_months(@months.to_i)
        .order(for_month: :desc, id: :desc)
    end

    def new_collective
      @months = params[:months].presence || 3
      result = IndicationService::RenderRecentMonths.call(@months)
      @user_recent_indication = result.data
    end

    def create_collective
      @months = params[:months].presence || 3
      @users = User.includes(:indications)

      result = IndicationService::CreateCollective.call(params[:indications])

      if result.success?
        redirect_to new_collective_moderators_indications_path, notice: 'Показания сохранены'
      else
        # @user_recent_indication = IndicationService::ShowCollectiveMonth.call
        # flash.now[:alert] = result.errors.join(', ')
        # render :new_collective, status: :unprocessable_entity
      end
    end

    def confirm_month
      result = IndicationService::ConfirmCurrentMonth.call

      if result.success?
        redirect_to new_collective_moderators_indications_path, notice: 'Показания сохранены'
      else
        @months = params[:months].presence || 3
        result = IndicationService::RenderRecentMonths.call(@months)
        @user_recent_indication = result.data

        @errors = result.errors
        render :new_collective, status: :unprocessable_entity
      end
    end

    def new_reset_electricity_meter
      @user = User.find(params[:user_id])
      @last_indication_old_meter = Indication.new
      @zero_indication_new_meter = Indication.new
      @new_indication_new_meter = Indication.new
      @last_indication = Indication.actual(@user).first
    end

    def create_reset_electricity_meter
      @user = User.find(params[:user_id])
      result = IndicationService::CreateReset.call(@user, indications_reset_params)

      if result.success?
        redirect_to moderators_indication_path(@user), notice: "Показания успешно сохранены"
      else
        @last_indication_old_meter = @user.indications.build(indications_reset_params[:last_indication_old_meter])
        @new_indication_new_meter = @user.indications.build(indications_reset_params[:new_indication_new_meter])
        @zero_indication_new_meter = @user.indications.build(all_day_reading: 0, is_correct: false)
        render :new_reset_electricity_meter, status: :unprocessable_entity
      end
    end

    # def new_calculate

    # end

    # def create_calculate
    #   indication = Indication.find(params[:id])
    #   render json: indication
    # end

    # def calculate_collective
    #   user_month_indications = IndicationService::ShowCollectiveMonth.call

    #   render json: user_month_indications
    # end

    private

    def indications_params
      base = @user.tariff_mono? ? params.require(:indication).permit(:all_day_reading) : params.require(:indication).permit(:day_time_reading, :night_time_reading)
      base.merge(user_id: @user.id)
    end

    def indications_reset_params
      if @user.tariff_mono?
        {
          last_indication_old_meter: params.require(:last_indication_old_meter).permit(:all_day_reading).merge(is_correct: false),
          zero_indication_new_meter: { all_day_reading: 0, is_correct: false },
          new_indication_new_meter: params.require(:new_indication_new_meter).permit(:all_day_reading).merge(is_correct: true)
        }
      else
        {
          last_indication_old_meter: params.require(:last_indication_old_meter).permit(:day_time_reading, :night_time_reading).merge(is_correct: false),
          zero_indication_new_meter: { day_time_reading: 0, night_time_reading: 0, is_correct: false },
          new_indication_new_meter: params.require(:new_indication_new_meter).permit(:day_time_reading, :night_time_reading).merge(is_correct: true)
        }
      end
    end
  end
end

module Moderators
  class IndicationsController < Users::BaseController
    before_action :set_indication_and_then_user, only: [:edit, :update]
    before_action :set_user, only: [:new, :create, :new_reset_electricity_meter, :create_reset_electricity_meter]
    before_action :set_months, only: [:show, :new_collective, :create_collective]

    def new
      @indication = Indication.new
      @last_indication = Indication.actual(@user).first
    end

    def create
      @indication = Indication.new(indications_params)

      if @indication.save
        redirect_to moderators_indication_path(@user), notice: 'Показания сохранены'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @last_indication = Indication.actual(@user).where.not(id: @indication.id).first
    end

    def update
      if @indication.update(indications_params)
        redirect_to moderators_indication_path(@indication, id: @indication.user.id), notice: 'Показания обновлены'
      else
        @last_indication = Indication.actual(@user).where.not(id: @indication.id).first
        render :edit, status: :unprocessable_entity
      end
    end

    def show
      @user = User.find(params[:id])
      @user_indications = Indication
        .where(user: @user)
        .for_recent_months(@months.to_i)
        .order(for_month: :desc, id: :desc)
    end

    def new_collective
      result = IndicationService::RenderRecentMonths.call(@months)
      @user_recent_indication = result.data
    end

    def create_collective
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
      @last_indication_old_meter = Indication.new
      @zero_indication_new_meter = Indication.new
      @new_indication_new_meter = Indication.new
      @last_indication = Indication.actual(@user).first
    end

    def create_reset_electricity_meter
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

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_months
      @months = params[:months].presence || 3
    end

    def set_indication_and_then_user
      @indication = Indication.find(params[:id])
      @user = @indication.user
    end

    def indications_params
      base = @user.tariff_mono? ? params.require(:indication).permit(:all_day_reading, :is_correct) : params.require(:indication).permit(:day_time_reading, :night_time_reading, :is_correct)
      base.merge(user_id: @user.id)
    end

    def indications_reset_params
      IndicationService::ResetParamsBuilder.call(@user, params)
    end
  end
end

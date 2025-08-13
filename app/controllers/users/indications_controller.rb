module Users
  class IndicationsController < Users::BaseController
    def new_reset_electricity_meter
      @user = User.find(params[:user_id])
      @last_indication_old_metter = Indication.new
      @zero_indication_new_metter = Indication.new
      @new_indication_new_metter = Indication.new
      @last_indication = Indication.actual(@user).first
    end

    def create_reset_electricity_meter
      @user = User.find(params[:user_id])

      if @user.tariff_mono?
        @last_indication_old_metter = @user.indications.build(params.require(:last_indication_old_metter).permit(:all_day_reading).merge(is_correct: false))
        @zero_indication_new_metter = @user.indications.build(all_day_reading: 0, is_correct: false)
        @new_indication_new_metter = @user.indications.build(params.require(:new_indication_new_metter).permit(:all_day_reading).merge(is_correct: true))
      else
        @last_indication_old_metter = @user.indications.build(params.require(:last_indication_old_metter).permit(:day_time_reading, :night_time_reading).merge(is_correct: false))
        @zero_indication_new_metter = @user.indications.build(day_time_reading: 0, night_time_reading: 0, is_correct: false)
        @new_indication_new_metter = @user.indications.build(params.require(:new_indication_new_metter).permit(:day_time_reading, :night_time_reading).merge(is_correct: true))
      end

      # @last_indication_old_metter.skip_previous_check = true
      @zero_indication_new_metter.skip_previous_check = true
      # @new_indication_new_metter.skip_previous_check = true

      Indication.transaction do
        @last_indication_old_metter.save!
        @zero_indication_new_metter.save!
        @new_indication_new_metter.save!
      end

      redirect_to indications_path(@user), notice: "Показания успешно сохранены"
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = "Ошибка при сохранении показаний: #{e.message}"
      render :new_reset_electricity_meter, status: :unprocessable_entity
    end

    private

    def indication_params
      params.require(:indications).permit(
        last_indication_old_metter: [:for_month, :all_day_reading, :day_time_reading, :night_time_reading],
        new_indication_new_metter: [:for_month, :all_day_reading, :day_time_reading, :night_time_reading]
      )
    end

  end
end
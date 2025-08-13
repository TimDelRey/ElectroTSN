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

      # Создаем объекты Indication для каждого из 3-х типов показаний
      @last_indication_old_metter = @user.indications.build(indication_params[:last_indication_old_metter])
      @new_indication_new_metter = @user.indications.build(indication_params[:new_indication_new_metter])

      if @user.tariff_mono?
        @zero_indication_new_metter = @user.indications.build(all_day_reading: 0)
      else
        @zero_indication_new_metter = @user.indications.build(day_time_reading: 0, night_time_reading: 0)
      end

      Indication.transaction do
        @last_indication_old_metter.save!
        @zero_indication_new_metter.save!
        @new_indication_new_metter.save!
      end

      redirect_to user_indications_path(@user), notice: "Показания успешно сохранены"

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
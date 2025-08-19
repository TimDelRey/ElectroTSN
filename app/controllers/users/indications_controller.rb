# module Users
#   class IndicationsController < Users::BaseController
#     before_action :set_user, only: %i[new_reset_electricity_meter create_reset_electricity_meter]

#     def new_reset_electricity_meter
#       @last_indication_old_metter = Indication.new
#       @zero_indication_new_metter = Indication.new
#       @new_indication_new_metter = Indication.new
#       @last_indication = Indication.actual(@user).first
#     end

#     def create_reset_electricity_meter
#       result = IndicationService::CreateReset.call(@user, indications_params)

#       if result
#         redirect_to indications_path(@user), notice: "Показания успешно сохранены"
#       else
#         flash.now[:alert] = "Ошибка при сохранении показаний: #{e.message}"
#         render :new_reset_electricity_meter, status: :unprocessable_entity
#       end
#     end

#     private

#     def set_user
#       @user = User.find(params[:user_id])
#     end

#     def indications_params
#       if @user.tariff_mono?
#         {
#           last_indication_old_metter: params.require(:last_indication_old_metter).permit(:all_day_reading).merge(is_correct: false),
#           zero_indication_new_metter: { all_day_reading: 0, is_correct: false },
#           new_indication_new_metter: params.require(:new_indication_new_metter).permit(:all_day_reading).merge(is_correct: true)
#         }
#       else
#         {
#           last_indication_old_metter: params.require(:last_indication_old_metter).permit(:day_time_reading, :night_time_reading).merge(is_correct: false),
#           zero_indication_new_metter: { day_time_reading: 0, night_time_reading: 0, is_correct: false },
#           new_indication_new_metter: params.require(:new_indication_new_metter).permit(:day_time_reading, :night_time_reading).merge(is_correct: true)
#         }
#       end
#     end
#   end
# end

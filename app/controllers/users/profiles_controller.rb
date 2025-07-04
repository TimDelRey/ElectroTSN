module Users
  class ProfilesController < BaseController
    before_action: set_user, only: %i[edit update]
    def show
      # render json: current_user
    end

    def edit; end

    def update
      if @user.update(profile_params)
        redirect_to profile_path, notice: 'Данные обновлены.'
      else
        puts @user.errors.full_messages.inspect
        render :edit
      end
    end

    private

    def set_user
      @user = current_user
    end

    def profile_params
      permitted = params.require(:user).permit(:first_name, :name, :last_name, :email, :place_number, :password, :password_confirmation)

      if permitted[:password].blank?
        permitted.delete(:password)
        permitted.delete(:password_confirmation)
      end

      permitted
    end
  end
end

require 'rails_helper'
describe Users::ProfilesController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }

  # before do
  #   allow(controller).to receive(:authenticate_user!)
  # end

  before do
    sign_in user
  end

  describe 'shows users profile' do
    it 'renders profile' do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'changes profile' do
    context 'with valid attributes' do
      it 'updates the user' do
        patch :update, params: { user: { first_name: 'неИванов' } }
        user.reload
        expect(user.first_name).to eq('неИванов')
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'with blank password' do
      it 'updates other attributes and ignores password' do
        old_encrypted_password = user.encrypted_password
        patch :update, params: {
          user: {
            name: 'неИван',
            password: '',
            password_confirmation: ''
          }
        }
        user.reload
        expect(user.name).to eq('неИван')
        expect(user.encrypted_password).to eq(old_encrypted_password)
      end
    end

    context 'with different password confirm' do
      it 'renders edit with errors' do
      end
    end

    context 'without place_number' do
      it 'renders edit with errors' do
        patch :update, params: { user: { email: '' } }
        expect(response).to render_template(:edit)
        expect(assigns(:user).errors[:email]).to be_present
      end
    end
  end
end

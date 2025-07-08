require 'rails_helper'

RSpec.describe TariffsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views
  describe "GET /index" do
    let! (:user) { create(:user) }
    let! (:tariff_1) { create(:tariff, title: 'Tariff_1') }
    let! (:tariff_2) { create(:tariff, title: 'Tariff_2', is_default: true, discription: 'show') }
    before do
      sign_in user
      get :index
    end

    context 'when only valid tariffs exist' do
      it 'show valid tariffs' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Tariff_1')
        expect(response.body).to include('Tariff_2')
      end
    end

    context 'when are some same title' do
      it 'show uniq tariffs' do
        begin
          create(:tariff, title: 'Tariff_2', is_default: true, discription: 'no_show')
        rescue ActiveRecord::RecordInvalid
        end

        get :index

        expect(response.body).to include('Tariff_1')
        expect(response.body).to include('show')
        expect(response.body).not_to include('no_show')
      end
    end
  end
end

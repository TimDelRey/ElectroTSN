require 'rails_helper'

RSpec.describe IndicationsController, type: :controller do
  describe "action show_person" do
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

  describe "action show_month_collective" do
  end
end

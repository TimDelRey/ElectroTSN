require 'rails_helper'

RSpec.describe Moderators::IndicationsController, type: :controller do
  render_views
  let!(:mono_user) { create(:user, tariff: 'mono') }
  let!(:duo_user) { create(:user) }
  let!(:mono_prev_indication) { create(:indication, user: mono_user, all_day_reading: 40, for_month: Date.today - 1.month) }
  let!(:duo_prev_indication) { create(:indication, user: duo_user, day_time_reading: 140, night_time_reading: 110, for_month: Date.today - 1.month) }
  let!(:valid_mono_params) { { user_id: mono_user.id, indication: { all_day_reading: 100 } } }
  let!(:valid_duo_params) { { user_id: duo_user.id, indication: { day_time_reading: 300, night_time_reading: 200 } } }
  let!(:invalid_mono_params) { { user_id: mono_user.id, indication: { all_day_reading: '' } } }
  let!(:invalid_duo_params) { { user_id: duo_user.id, indication: { day_time_reading: '', night_time_reading: '' } } }

  before do
    allow(controller).to receive(:authenticate_user!)
  end

  describe 'create process' do
    context 'when valid data' do
      it 'indiication mono-tariff is created' do
        expect { post :create, params: valid_mono_params }.to change(Indication, :count).by(1)

        expect(response).to redirect_to(moderators_indication_path(mono_user))
        indication = Indication.last
        expect(indication.user).to eq(mono_user)
        expect(indication.all_day_reading).to eq(100)
        expect(indication.is_correct).to eq(nil)
        expect(indication.for_month).to eq(Date.today)
      end

      it 'indication duo-tariff is created' do
        expect { post :create, params: valid_duo_params }.to change(Indication, :count).by(1)

        expect(response).to redirect_to(moderators_indication_path(duo_user))
        indication = Indication.last
        expect(indication.user).to eq(duo_user)
        expect(indication.day_time_reading).to eq(300)
        expect(indication.night_time_reading).to eq(200)
        expect(indication.is_correct).to eq(nil)
        expect(indication.for_month).to eq(Date.today)
      end
    end

    context 'when reading is empty' do
      it 'render :new again for mono-traiff' do
        expect { post :create, params: invalid_mono_params }.not_to change(Indication, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'render :new again for duo-traiff' do
        expect { post :create, params: invalid_duo_params }.not_to change(Indication, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'update process' do
    context 'when valid data' do
      it 'mono-taiff indiication is updated' do
        expect { patch :update, params: valid_mono_params.merge(id: mono_prev_indication.id) }.not_to change(Indication, :count)

        expect(response).to redirect_to(moderators_indication_path(mono_prev_indication, id: mono_user.id))
        mono_prev_indication.reload
        expect(mono_prev_indication.all_day_reading).to eq(100)
      end
      it 'duo-taiff indiication is updated' do
        expect { patch :update, params: valid_duo_params.merge(id: duo_prev_indication.id) }.not_to change(Indication, :count)

        expect(response).to redirect_to(moderators_indication_path(duo_prev_indication, id: duo_user.id))
        duo_prev_indication.reload
        expect(duo_prev_indication.day_time_reading).to eq(300)
        expect(duo_prev_indication.night_time_reading).to eq(200)
      end
    end

    context 'when reading is empty' do
      it 'render :edit again for mono-tariff' do
        expect { patch :update, params: invalid_mono_params.merge(id: mono_prev_indication.id) }.not_to change(Indication, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'render :edit again for duo-tariff' do
        expect { patch :update, params: invalid_duo_params.merge(id: duo_prev_indication.id) }.not_to change(Indication, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'show action' do
    context 'when click 1 user' do
      it 'show mono-indications' do
        get :show, params: { id: mono_user.id }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(mono_prev_indication.all_day_reading.to_i.to_s)
      end
      it 'show duo-indications' do
        get :show, params: { id: duo_user.id }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(duo_prev_indication.day_time_reading.to_i.to_s)
        expect(response.body).to include(duo_prev_indication.night_time_reading.to_i.to_s)
      end
    end

    # context 'when need not default 3 months' do
    #   it 'show 4 months for mono-tariff' do
    #   end
    #   it 'show 2 months for duo-tariff' do
    #   end
    # end
  end

  describe 'create collective process' do
    before do
      mono_prev_indication.update!(is_correct: true)
      duo_prev_indication.update!(is_correct: true)
    end

    context 'when user want watch any last indncations of all users' do
      let!(:mono_current_indication) { create(:indication, user: mono_user, all_day_reading: 60) }
      let!(:duo_current_indication) { create(:indication, user: duo_user, day_time_reading: 160, night_time_reading: 130) }

      it 'show indications of default last months' do
        get :new_collective

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(mono_prev_indication.all_day_reading.to_i.to_s)
        expect(response.body).to include(duo_prev_indication.day_time_reading.to_i.to_s)
        expect(response.body).to include(duo_prev_indication.night_time_reading.to_i.to_s)
        expect(response.body).to include(mono_current_indication.all_day_reading.to_i.to_s)
        expect(response.body).to include(duo_current_indication.day_time_reading.to_i.to_s)
        expect(response.body).to include(duo_current_indication.night_time_reading.to_i.to_s)
      end
    end

    context 'when valid data' do
      let!(:collective_params) {
        {
          indications: {
            mono_user.id.to_s => {
              all_day_reading: 100
            },
            duo_user.id.to_s => {
              day_time_reading: 200,
              night_time_reading: 150
            }
          }
        }
      }

      it 'created indication where readings is present' do
        expect { post :create_collective, params: collective_params }.to change(Indication, :count).by(2)

        expect(response).to redirect_to(new_collective_moderators_indications_path)
      end
    end

    # context 'when need not default 3 months' do
    #   it 'show 4 months' do
    #   end
    # end
  end

  describe 'confirm_month process' do
    context 'when values of current month are present' do
      it 'indications are created' do
      end
    end
    context 'when current month reading is present' do
      it 'reading of current month become is_correct: true' do
      end
    end
    context 'when readings of current month are empty' do
      it 'do nothing' do
      end
    end
  end

  describe 'reset metter process' do
    context 'when indication valid' do
      it 'created 3 indications' do
      end
    end

    context 'when invalid indication' do
      it 'created new zero indication' do
      end
      it 'created same last month indication' do
      end
      it 'created same last and new zero indication' do
      end
    end
  end
end

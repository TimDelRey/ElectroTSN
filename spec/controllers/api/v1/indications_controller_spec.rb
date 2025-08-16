require 'rails_helper'

RSpec.describe Api::V1::IndicationsController, type: :controller do
  let!(:user_1) { create(:user, tariff: 'mono') }
  let!(:user_2) { create(:user) }

  let!(:mono_indication_current_month_incorrect_1) { create(:indication, all_day_reading: 140, for_month: Date.today, is_correct: false, user: user_1) }
  let!(:mono_indication_current_month_incorrect_2) { create(:indication, all_day_reading: 130, for_month: Date.today, user: user_1) }
  let!(:mono_indication_current_month_correct_1) { create(:indication, all_day_reading: 120, for_month: Date.today, is_correct: true, user: user_1) }
  let!(:mono_indication_previous_month_correct) { create(:indication, all_day_reading: 110, for_month: Date.today.prev_month, is_correct: true, user: user_1) }

  let!(:duo_indication_current_month_incorrect_1) { create(:indication, day_time_reading: 340, night_time_reading: 240, for_month: Date.today, is_correct: false, user: user_2) }
  let!(:duo_indication_current_month_incorrect_2) { create(:indication, day_time_reading: 330, night_time_reading: 230, for_month: Date.today, user: user_2) }
  let!(:duo_indication_current_month_correct) { create(:indication, day_time_reading: 320, night_time_reading: 220, for_month: Date.today, is_correct: true, user: user_2) }
  let!(:duo_indication_previous_month_correct) { create(:indication, day_time_reading: 310, night_time_reading: 210, for_month: Date.today.prev_month, is_correct: true, user: user_2) }

  let!(:current_month) { Date.today.to_s }
  let!(:previous_month) { Date.today.prev_month.to_s }
  let!(:next_month) { Date.today.next_month.to_s }

  describe 'action show_person for users with mono tariff' do
    subject(:perform_request) { get :show_person, params: request_params }

    context 'when valid params' do
      let(:request_params) { { user_id: user_1.id, date: current_month } }

      it 'render correct json' do
        perform_request
        json = JSON.parse(response.body)

        returned_ids = json.map { |i| i["id"] }

        expect(returned_ids).to include(mono_indication_current_month_correct_1.id)
        expect(returned_ids).not_to include(mono_indication_current_month_incorrect_1.id)
        expect(returned_ids).not_to include(mono_indication_current_month_incorrect_2.id)
        expect(returned_ids).not_to include(mono_indication_previous_month_correct.id)
      end
    end

    context 'when invalid params:' do
      context 'invalid date' do
        let(:request_params) { { user_id: user_1.id, date: next_month } }
        it 'render nul' do
          perform_request
          json = JSON.parse(response.body)

          expect(json).to eq([nil])
        end
      end
      context 'invalid user_id' do
        let(:request_params) { { user_id: 'not_id', date: current_month } }
        it 'render error' do
          perform_request

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when reset electricity metter' do
      let(:request_params) { { user_id: user_1.id, date: current_month } }
      let!(:mono_indication_current_month_correct_2) { create(:indication, all_day_reading: 120, for_month: Date.today, is_correct: false, user: user_1) }
      let!(:mono_indication_current_month_zero) { create(:indication, all_day_reading: 0, for_month: Date.today, is_correct: false, user: user_1, skip_previous_check: true) }

      it 'render before_reset indication and current indication' do
        perform_request
        json = JSON.parse(response.body)

        returned_ids = json.map { |i| i["id"] }

        expect(returned_ids).to include(mono_indication_current_month_correct_1.id)
        expect(returned_ids).to include(mono_indication_current_month_correct_2.id)
        expect(returned_ids).not_to include(mono_indication_current_month_zero.id)
        expect(returned_ids).not_to include(mono_indication_current_month_incorrect_1.id)
        expect(returned_ids).not_to include(mono_indication_current_month_incorrect_2.id)
        expect(returned_ids).not_to include(mono_indication_previous_month_correct.id)
      end
    end
  end

  describe 'action show_person for users with duo tariff' do
  end

  describe 'action show_month_collective for all users' do
  end
end

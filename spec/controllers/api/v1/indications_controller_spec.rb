require 'rails_helper'

RSpec.describe Api::V1::IndicationsController, type: :controller do
  let!(:user_1) { create(:user, tariff: 'mono') }
  let!(:user_2) { create(:user) }

  let!(:mono_indication_current_month_incorrect_1) { create(:indication, all_day_reading: 140, for_month: Date.today, is_correct: false, user: user_1) }
  let!(:mono_indication_current_month_incorrect_2) { create(:indication, all_day_reading: 130, for_month: Date.today, user: user_1) }
  let!(:mono_indication_current_month_correct_1) { create(:indication, all_day_reading: 120, for_month: Date.today, is_correct: true, user: user_1) }
  let!(:mono_indication_previous_month_correct_1) { create(:indication, all_day_reading: 110, for_month: Date.today.prev_month, is_correct: true, user: user_1) }

  let!(:duo_indication_current_month_incorrect_1) { create(:indication, day_time_reading: 340, night_time_reading: 240, for_month: Date.today, is_correct: false, user: user_2) }
  let!(:duo_indication_current_month_incorrect_2) { create(:indication, day_time_reading: 330, night_time_reading: 230, for_month: Date.today, user: user_2) }
  let!(:duo_indication_current_month_correct_1) { create(:indication, day_time_reading: 320, night_time_reading: 220, for_month: Date.today, is_correct: true, user: user_2) }
  let!(:duo_indication_previous_month_correct_1) { create(:indication, day_time_reading: 310, night_time_reading: 210, for_month: Date.today.prev_month, is_correct: true, user: user_2) }

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
        expect(returned_ids).not_to include(mono_indication_previous_month_correct_1.id)
      end
    end

    context 'when reset electricity metter' do
      let(:request_params) { { user_id: user_1.id, date: current_month } }
      let!(:mono_indication_current_month_correct_2) { create(:indication, all_day_reading: 120, for_month: current_month, is_correct: false, user: user_1) }
      let!(:mono_indication_current_month_zero) { create(:indication, all_day_reading: 0, for_month: current_month, is_correct: false, user: user_1, skip_previous_check: true) }

      it 'render before_reset indication and current indication' do
        perform_request
        json = JSON.parse(response.body)

        returned_ids = json.map { |i| i["id"] }

        expect(returned_ids).to include(mono_indication_current_month_correct_1.id)
        expect(returned_ids).to include(mono_indication_current_month_correct_2.id)
        expect(returned_ids).not_to include(mono_indication_current_month_zero.id)
        expect(returned_ids).not_to include(mono_indication_current_month_incorrect_1.id)
        expect(returned_ids).not_to include(mono_indication_current_month_incorrect_2.id)
        expect(returned_ids).not_to include(mono_indication_previous_month_correct_1.id)
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
  end

  describe 'action show_person for users with duo tariff' do
    subject(:perform_request) { get :show_person, params: request_params }

    context 'when valid params' do
      let(:request_params) { { user_id: user_2.id, date: current_month } }

      it 'render correct json' do
        perform_request
        json = JSON.parse(response.body)

        returned_ids = json.map { |i| i["id"] }

        expect(returned_ids).to include(duo_indication_current_month_correct_1.id)
        expect(returned_ids).not_to include(duo_indication_current_month_incorrect_1.id)
        expect(returned_ids).not_to include(duo_indication_current_month_incorrect_2.id)
        expect(returned_ids).not_to include(duo_indication_previous_month_correct_1.id)
      end
    end

    context 'when reset electricity metter' do
      let(:request_params) { { user_id: user_2.id, date: current_month } }
      let!(:duo_indication_current_month_correct_2) { create(:indication, day_time_reading: 500, night_time_reading: 400, for_month: current_month, is_correct: false, user: user_2) }
      let!(:duo_indication_current_month_zero) { create(:indication, day_time_reading: 0, night_time_reading: 0, for_month: current_month, is_correct: false, user: user_2, skip_previous_check: true) }

      it 'render before_reset indication and current indication' do
        perform_request
        json = JSON.parse(response.body)

        returned_ids = json.map { |i| i["id"] }

        expect(returned_ids).to include(duo_indication_current_month_correct_1.id)
        expect(returned_ids).to include(duo_indication_current_month_correct_2.id)
        expect(returned_ids).not_to include(duo_indication_current_month_zero.id)
        expect(returned_ids).not_to include(duo_indication_current_month_incorrect_1.id)
        expect(returned_ids).not_to include(duo_indication_current_month_incorrect_2.id)
        expect(returned_ids).not_to include(duo_indication_previous_month_correct_1.id)
      end
    end

    context 'when invalid params:' do
      context 'invalid date' do
        let(:request_params) { { user_id: user_2.id, date: next_month } }
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
  end

  describe 'action show_month_collective for all users' do
    subject(:perform_request) { get :show_month_collective, params: { date: current_month } }

    context 'when indications is valid without zero-indications' do
      it 'render 2 indications per user(last and current month)' do
        perform_request
        json = JSON.parse(response.body)

        mono_json = json[user_1.id.to_s]
        expect(mono_json.size).to eq(2)

        mono_ids = mono_json.map { |i| i["id"] }
        expect(mono_ids).to include(mono_indication_current_month_correct_1.id)
        expect(mono_ids).to include(mono_indication_previous_month_correct_1.id)
        expect(mono_ids).not_to include(mono_indication_current_month_incorrect_1.id)
        expect(mono_ids).not_to include(mono_indication_current_month_incorrect_2.id)

        duo_json = json[user_2.id.to_s]
        expect(duo_json.size).to eq(2)

        duo_ids = duo_json.map { |i| i["id"] }
        expect(duo_ids).to include(duo_indication_current_month_correct_1.id)
        expect(duo_ids).to include(duo_indication_previous_month_correct_1.id)
        expect(duo_ids).not_to include(duo_indication_current_month_incorrect_1.id)
        expect(duo_ids).not_to include(duo_indication_current_month_incorrect_2.id)
      end
    end

    context 'when indication of mono-tariff is valid with zero-indication in current month and
    indication of duo-tariff is valid with zero-indication in previous month ' do
      let!(:mono_indication_current_month_correct_2) { create(:indication, all_day_reading: 120, for_month: current_month, is_correct: false, user: user_1) }
      let!(:mono_indication_current_month_zero) { create(:indication, all_day_reading: 0, for_month: current_month, is_correct: false, user: user_1, skip_previous_check: true) }
      let!(:duo_indication_previous_month_correct_2) { create(:indication, day_time_reading: 500, night_time_reading: 400, for_month: previous_month, is_correct: false, user: user_2) }
      let!(:duo_indication_previous_month_zero) { create(:indication, day_time_reading: 0, night_time_reading: 0, for_month: previous_month, is_correct: false, user: user_2, skip_previous_check: true) }
      it 'render 3 indications to user with zero-reading' do
        perform_request

        json = JSON.parse(response.body)

        mono_json = json[user_1.id.to_s]
        expect(mono_json.size).to eq(3)

        mono_ids = mono_json.map { |i| i["id"] }
        expect(mono_ids).to include(mono_indication_current_month_correct_1.id)
        expect(mono_ids).to include(mono_indication_current_month_correct_2.id)
        expect(mono_ids).to include(mono_indication_previous_month_correct_1.id)
        expect(mono_ids).not_to include(mono_indication_current_month_incorrect_1.id)
        expect(mono_ids).not_to include(mono_indication_current_month_incorrect_2.id)
        expect(mono_ids).not_to include(mono_indication_current_month_zero.id)

        duo_json = json[user_2.id.to_s]
        expect(duo_json.size).to eq(2)

        duo_ids = duo_json.map { |i| i["id"] }
        expect(duo_ids).to include(duo_indication_current_month_correct_1.id)
        expect(duo_ids).to include(duo_indication_previous_month_correct_1.id)
        expect(duo_ids).not_to include(duo_indication_current_month_incorrect_1.id)
        expect(duo_ids).not_to include(duo_indication_current_month_incorrect_2.id)
        expect(duo_ids).not_to include(duo_indication_previous_month_correct_2.id)
        expect(duo_ids).not_to include(duo_indication_previous_month_zero.id)
      end
    end
  end
end

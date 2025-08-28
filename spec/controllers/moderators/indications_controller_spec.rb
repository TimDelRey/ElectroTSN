require 'rails_helper'

RSpec.describe Moderators::IndicationsController, type: :controller do
  describe 'for users with mono tariff' do
    subject(:perform_request) { get :show_person, params: request_params }

    context 'create process' do
      context 'when valid data' do
        it 'indiication mono-tariff is created' do
        end
        it 'indication dou-tariff is created' do
        end
      end

      context 'when reading is empty' do
        it 'render :new again for mono-traiff' do
        end

        it 'render :new again for duo-traiff' do
        end
      end
    end

    context 'update process' do
      context 'when valid data' do
        it 'mono-taiff indiication is updated' do
        end
        it 'duo-taiff indiication is updated' do
        end
      end

      context 'when reading is empty' do
        it 'render :edit again for mono-tariff' do
        end
        it 'render :edit again for duo-tariff' do
        end
      end
    end

    context 'show action'
      context 'when click 1 user' do
        it 'show mono-indications' do
        end
        it 'show duo-indications' do
        end
      end

      # context 'when need not default 3 months' do
      #   it 'show 4 months for mono-tariff' do
      #   end
      #   it 'show 2 months for duo-tariff' do
      #   end
      # end
    end

    context 'create collective process' do
      context 'when valid data' do
        it 'created indication where readings is present' do
        end
      end

      # context 'when need not default 3 months' do
      #   it 'show 4 months' do
      #   end
      # end
    end

    context 'confirm_month process' do
      context 'when values of current month are present' do
        it 'indications are created' do
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

    context 'reset metter process' do
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
end

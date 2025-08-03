# == Schema Information
#
# Table name: indications
#
#  id                 :bigint           not null, primary key
#  all_day_reading    :float
#  day_time_reading   :float
#  for_month          :date             not null
#  is_correct         :boolean          default(TRUE)
#  night_time_reading :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_indications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Indication, type: :model do
  let(:duo_user) { create(:user, tariff: 'duo') }
  let(:previous_month) { Date.today - 1.month }

  subject { build(:indication, user: user) }

  describe 'testing mono indication' do
    let(:user) { create(:user, tariff: 'mono') }
    let!(:previous_indication) { create(:indication, for_month: previous_month, all_day_reading: 50, user: user) }

    context 'when valid indication' do
      it 'indication now bigger than previous is saved' do
        subject.all_day_reading = 100
        
        expect(subject).to be_valid
        expect(subject.save).to eq(true)

        expect(subject.all_day_reading).to eq(100)
        expect(subject.day_time_reading).to be_nil
        expect(subject.night_time_reading).to be_nil
        expect(subject.for_month).to eq(Date.today)
        expect(subject.is_correct).to eq(true)
        expect(subject.user).to eq(user)
      end
    end

    context 'when invalid indication' do
      it 'indication wasnt saved' do
        subject.all_day_reading = 'beskonechnot ne predel!!!'

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end

    context 'when indication is different users tariff' do
      it 'indication wasnt saved' do
      end
    end

    context 'when 2 indication/month has is_correct mark' do
      it 'indication wasnt saved' do
      end
    end

    context 'when indication now less previous' do
      it 'indication wasnt saved' do
      end
    end
  end
end

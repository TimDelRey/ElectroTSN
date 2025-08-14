# == Schema Information
#
# Table name: indications
#
#  id                 :bigint           not null, primary key
#  all_day_reading    :float
#  day_time_reading   :float
#  for_month          :date             not null
#  is_correct         :boolean
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
  describe 'testing mono indication' do
    let!(:user) { create(:user, tariff: 'mono') }
    let!(:previous_indication) { create(:indication, for_month: Date.today - 1.month, all_day_reading: 50, user: user, is_correct: true) }

    subject { build(:indication, user: user) }

    context 'when valid data' do
      it 'indication now bigger than previous is saved' do
        subject.all_day_reading = 100

        expect(subject).to be_valid
        expect(subject.save).to eq(true)

        expect(subject.all_day_reading).to eq(100)
        expect(subject.day_time_reading).to be_nil
        expect(subject.night_time_reading).to be_nil
        expect(subject.for_month).to eq(Date.today)
        expect(subject.is_correct).to be_nil
        expect(subject.user).to eq(user)
        expect(subject.all_day_reading).to be > previous_indication.all_day_reading
      end
    end

    context 'when invalid data' do
      it 'indication is not saved' do
        subject.all_day_reading = 'beskonechnot ne predel!!!'

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end

    context 'when indication is different users tariff' do
      it 'indication is not saved' do
        subject.day_time_reading = 101
        subject.night_time_reading = 102

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end

    context 'when 2 indication/month has is_correct mark' do
      it 'indication is not saved' do
        subject.is_correct = true
        subject.all_day_reading = 100
        create(:indication, user: user, is_correct: true, for_month: Date.today, all_day_reading: 150)

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end

    context 'when the indication is now less than the previous ones' do
      it 'indication is not saved' do
        subject.all_day_reading = 10
        subject.is_correct = true

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
        expect(subject.all_day_reading).to be < previous_indication.all_day_reading
      end
    end

    context 'when indication with empty readings' do
      it 'indication is not saved' do
        build(:indication, user: user, is_correct: true, for_month: Date.today)

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end
  end

  describe 'testing duo indication' do
    let!(:user) { create(:user, tariff: 'duo') }
    let!(:previous_indication) { create(:indication, for_month: Date.today - 1.month, day_time_reading: 50, night_time_reading: 40, user: user, is_correct: true) }

    subject { build(:indication, user: user) }

    context 'when valid data' do
      it 'indication now bigger than previous is saved' do
        subject.day_time_reading = 100
        subject.night_time_reading = 90

        expect(subject).to be_valid
        expect(subject.save).to eq(true)

        expect(subject.all_day_reading).to be_nil
        expect(subject.day_time_reading).to eq(100)
        expect(subject.night_time_reading).to eq(90)
        expect(subject.for_month).to eq(Date.today)
        expect(subject.is_correct).to be_nil
        expect(subject.user).to eq(user)
        expect(subject.day_time_reading).to be > previous_indication.day_time_reading
        expect(subject.night_time_reading).to be > previous_indication.night_time_reading
      end
    end

    context 'when invalid data' do
      it 'indication is not saved' do
        subject.day_time_reading = 'beskonechnot ne predel!!!'

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end

    context 'when indication is different users tariff' do
      it 'indication is not saved' do
        subject.all_day_reading = 101

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
      end
    end

    context 'when the indication is now less than the previous ones' do
      it 'indication is not saved' do
        subject.day_time_reading = 10
        subject.is_correct = true

        expect(subject).not_to be_valid
        expect(subject.save).to eq(false)
        expect(subject.day_time_reading).to be < previous_indication.day_time_reading
      end
    end
  end
end

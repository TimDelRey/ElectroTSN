module Api
  module V1
    class IndicationsController < Users::BaseController
      # примерчик GET /api/v1/indications/show_person?user_id=42&date=2025-08-14
      def show_person
        user = User.find(params[:user_id])
        date = Date.parse(params[:date])
        indication = person_correct_indication(user, date)
        render json: indication
      end

      def show_month_collective
        date = Date.parse(params[:date])
        result = {}

        User.includes(:indications).find_each do |user|
          indications = person_indications(user, date)
          previous = person_correct_indication(user, date - 1.month)
          current_set = indications_for_current_month(indications)

          result[user.id] = [previous, *current_set]
        end

        render json: result
      end

      private
      
      def person_indications(user, date)
        month_range = date.beginning_of_month..date.end_of_month
        user.indications.where(for_month: month_range)
      end

      def person_correct_indication(user, date)
        person_indications(user, date).correct.first
      end

      def indications_for_current_month(indications)
        if indications.any? { |i| zero_reading?(i) }
          before_reset = indication_before_reset(indications)
          current = indications.where(is_correct: true).order(id: :desc).first
          [before_reset, current]
        else
          [indications.where(is_correct: true).order(id: :desc).first]
        end
      end

      def indication_before_reset(indications)
        zero_indication = indications.find { |i| zero_reading?(i) }
        return unless zero_indication

        indications
          .where("created_at < ?", zero_indication.created_at)
          .order(created_at: :desc)
          .first
      end

      def zero_reading?(indication)
        indication.all_day_reading.to_f.zero? || indication.day_time_reading.to_f.zero? || indication.night_time_reading.to_f.zero?
      end
    end
  end
end

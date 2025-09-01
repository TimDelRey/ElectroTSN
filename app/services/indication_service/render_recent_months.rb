module IndicationService
  class RenderRecentMonths
    include Service

    def initialize(months)
      @months = months
    end

    def call
      users = User.includes(:indications)

      user_recent_indication = {}
      users.each do |user|
      recent_indication = user.indications
        .order(for_month: :desc)
        .limit(@months)

        user_recent_indication[user] = recent_indication
      end
      success(user_recent_indication)
    end
  end
end

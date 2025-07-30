module IndicationsHelper
  def month_name(date)
    I18n.l(date, format: "%B").capitalize
  end

  def month_options
    today = Date.current.beginning_of_month
    (0..11).map do |i|
      month = today - i.months
      [I18n.l(month, format: '%B %Y').capitalize, month]
    end
  end
end

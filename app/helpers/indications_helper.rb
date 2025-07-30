module IndicationsHelper
  def month_name(date)
    I18n.l(date, format: "%B").capitalize
  end
end

class IndicationCollection
  def initialize(indications)
    @indications = indications
  end

  def for_month(month)
    @indications.correct.find { |i| i.for_month.beginning_of_month == month.beginning_of_month }
  end

  def current(month)
    @indications.correct.where(for_month: month..month.end_of_month).last || @indications.not_confirmed.where(for_month: month..month.end_of_month).last
  end
end

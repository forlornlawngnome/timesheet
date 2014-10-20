module StatsHelper
  def yearDropdown
    start = ApplicationHelper.rangeBeginning.year
    years = Hash.new

    (start..ApplicationHelper.getStartYear).each do |year|
      years[ApplicationHelper.dateRange(ApplicationHelper.getYearStart(year))] = year
    end
    return years
  end
end

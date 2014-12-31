module StatsHelper
  def yearDropdown
    start = ApplicationHelper.rangeBeginning.year
    years = Hash.new
    
    puts "Start Year: #{ApplicationHelper.rangeBeginning}"
    puts "End year: #{ApplicationHelper.getStartYear}"
    (start..ApplicationHelper.getStartYear).each do |year|
      years[ApplicationHelper.dateRange(ApplicationHelper.getYearStart(year))] = year
    end
    puts years.inspect
    return years
  end
end

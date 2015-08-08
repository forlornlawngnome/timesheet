module StatsHelper
  def yearDropdown
    years = Hash.new
    
    Year.order("year_start asc").each do |year|
      years[year.year_range] = year.id
    end
    return years
  end
end

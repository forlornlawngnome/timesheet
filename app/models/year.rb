class Year < ActiveRecord::Base
  attr_accessible :build_season_start, :year_end, :year_start
  
  def is_current_year?
    if !current_year.nil? && current_year.id == self.id
      return true
    end
    return false
  end
  def current_year
    Year.where("year_start <= ? and year_end >= ?",Date.today,Date.today).first
  end
end

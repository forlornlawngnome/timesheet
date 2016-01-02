class Year < ActiveRecord::Base
  #attr_accessible :build_season_start, :year_end, :year_start
  
  has_many :timelogs
  has_many :users, :through => :timelogs
  has_many :hour_overrides
  has_many :hour_exceptions
  has_many :week_exceptions
  
  def is_current_year?
    if !Year.current_year.nil? && Year.current_year.id == self.id
      return true
    end
    return false
  end
  def self.current_year
    year = Year.where("year_start <= ? and year_end >= ?",Date.today,Date.today).first
    if year.nil?
      return Year.new
    end
    return year
  end
  def self.find_year(date)
    year = Year.where("year_start <= ? and year_end >= ?",date,date).first
  end
  def year_range
    "#{self.year_start.year} - #{self.year_end.year}"
  end
  def self.preseason_weeks
    year = Year.current_year
    logs = Timelog.pre_season_hours(year)
    logs_grouped = logs.group_by{ |u| ApplicationHelper.toLocalTime(u.timein).beginning_of_week} rescue 0
    logs_grouped.count
    logger.debug( logs_grouped.inspect)
  end
end

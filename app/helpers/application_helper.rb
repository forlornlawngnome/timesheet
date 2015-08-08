module ApplicationHelper
  def user_signed_in?
    if current_user.nil?
      return false
    else
      return true
    end
  end
  def self.TimeZone
    Constants::TIMEZONE
  end
  def self.zone
    zone = ActiveSupport::TimeZone.new(ApplicationHelper.TimeZone)
  end
  def self.TimeOffset
    time = DateTime.now
    time.in_time_zone(ApplicationHelper.zone).formatted_offset
  end
  def self.toLocalTime(time)
    time.in_time_zone(ApplicationHelper.TimeZone)
  end
  def self.getYearStart(year)
    DateTime.new(year, ApplicationHelper.getStartMonth, 1, 0, 0, 0)
  end
  def self.getStartMonth
    Constants::YEAR_START
  end
  def self.getStartYear
    if Date.today.month > ApplicationHelper.getStartMonth
      start = Date.today.year
    else
      start = Date.today.year-1
    end
    return start
  end
  def self.getStartDate
    ##This has the year starting at the beginning of July
    DateTime.new(ApplicationHelper.getStartYear, ApplicationHelper.getStartMonth, 1, 0, 0, 0)
  end
  def self.getStartBuildDate
    ##This has the year starting at the beginning of July
    date = DateTime.new(ApplicationHelper.getStartYear+1, 1, 1, 0, 0, 0)
  end
  def self.today
  
    #If it's before 1am...
    if Time.now.in_time_zone(ApplicationHelper.TimeZone) < Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day + Constants::DAY_END.hours
      #then pretend it's still yesterday to give kids time to sign out
      Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day - 1.days
    else
      Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day
    end
  end
  def getWeeks
    year = Year.current_year
    if year.nil?
      return 
    end
    start = year.year_start
    (start..(Date.today+1)).group_by{ |u| u.beginning_of_week.strftime("%m/%d/%Y") }
  end
  
  def hoursBuildSeason(hours)
    hours>Constants::BUILD_HOURS.hours
  end
  def meetingsBuildSeason(number)
    number>=Constants::BUILD_MEETINGS
  end
  def meetingsPreSeason(number)
    number>=Constants::PRE_MEETINGS
  end
  
  def isPreSeason(time)
    if time.nil?
      return false
    end
    year = Year.current_year
    if time > year.year_start and time < year.build_season_start
      return true
    else
      return false
    end 
  end
  def isBuildSeason(time)
    if time.nil?
      return false
    end
    year = Year.current_year
    if time > year.build_season_start
      return true
    else
      return false
    end 
  end
  def self.dateRange(time)
    "#{time.year}-#{(time+1.year).year}"
  end
  def self.rangeBeginning
    log = Timelog.order("timein asc").first
    ApplicationHelper.getYearStart(log.timein.year)
  end
end

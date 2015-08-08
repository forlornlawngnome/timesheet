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
  def self.getStartDate
    Year.current_year.year_start.to_datetime
  end
  def self.getStartBuildDate
    Year.current_year.build_season_start.to_datetime
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
    if time > year.year_start and !isBuildSeason(time)
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
end

module ApplicationHelper
  def self.TimeZone
    'Eastern Time (US & Canada)'
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
  def self.getStartYear
    if Date.today.month > 7
      start = Date.today.year
    else
      start = Date.today.year-1
    end
    return start
  end
  def self.getStartDate
    ##This has the year starting at the beginning of July
    DateTime.new(ApplicationHelper.getStartYear, 7, 1, 0, 0, 0)
  end
  def self.getStartBuildDate
    ##This has the year starting at the beginning of July
    date = DateTime.new(ApplicationHelper.getStartYear+1, 1, 1, 0, 0, 0)
  end
  def self.today
  
    #If it's before 1am...
    if Time.now.in_time_zone(ApplicationHelper.TimeZone) < Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day + 1.hours
      #then pretend it's still yesterday to give kids time to sign out
      Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day - 1.days
    else
      Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day
    end
  end
  def getWeeks
    start = ApplicationHelper.getStartDate
    (start..Date.today).group_by{ |u| ApplicationHelper.toLocalTime(u).beginning_of_week.strftime("%m/%d/%Y") }
  end
  
  def hoursBuildSeason(hours)
    hours>6.hours
  end
  def meetingsBuildSeason(number)
    number>=2
  end
  def meetingsPreSeason(number)
    number>=1
  end
  
  def isPreSeason(time)
    Date.today.month > 7 
  end
  def isBuildSeason(time)
    Date.today.month < 7 
  end

end

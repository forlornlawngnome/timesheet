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
  def self.today
  
    #If it's before 1am...
    if Time.now.in_time_zone(ApplicationHelper.TimeZone) < Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day + Constants::DAY_END.hours
      #then pretend it's still yesterday to give kids time to sign out
      Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day - 1.days
    else
      Time.now.in_time_zone(ApplicationHelper.TimeZone).beginning_of_day
    end
  end
end

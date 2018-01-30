class Week < ActiveRecord::Base
  belongs_to :year
  has_many :hour_exceptions, dependent: :nullify
  has_many :week_exceptions, dependent: :nullify
  has_many :timelogs, dependent: :nullify
  has_many :flex_hours, dependent: :nullify
  
  
  scope :past, -> { where("year_id = ? AND week_start <= ?", Year.current_year, ApplicationHelper.today)}
  scope :future, -> { where("year_id = ? AND week_end >=?", Year.current_year, ApplicationHelper.today)}
  scope :this_year, -> { where("year_id = ?", Year.current_year)}
  scope :summer, -> { where(:season=>"Summer")}
  scope :preseason, -> { where(:season=>"Preseason")}
  scope :build_season, -> { where(:season=>"Build Season")}
  
  def week_range
    "#{self.week_start.strftime("%m/%d/%y") } - #{self.week_end.strftime("%m/%d/%y") }"
  end
  def short_week_range
    "#{self.week_start.strftime("%m/%d") } - #{self.week_end.strftime("%m/%d") }"
  end
  def self.find_week(date)
    week = Week.where("week_start <= ? and week_end >= ?",date,date).first
  end
  def self.current_week
    week = Week.where("week_start <= ? and week_end >= ?",Date.current,Date.current).first
    if week.nil?
      return Week.new
    end
    return week
  end
  ########### Season Check #######
  def is_preseason
    if self.season=="Preseason"
      return true
    else
      return false
    end
  end
  def is_build_season
    if self.season=="Build Season"
      return true
    else
      return false
    end
  end
  ########### Week Requirements ##########
  def met_weekly_reqs(user)
    if is_preseason
      return true
    elsif is_build_season
      return user_met_all_weekly_build_reqs(user)
    else
      return true
    end
  end
  ### Build Season Reqs #####
  def user_met_all_weekly_build_reqs(user)
    if user.is_mentor
      return true
    else
      #
      exception = get_users_hour_exceptions(user)
      if !exception.nil? && !exception.empty?
        ex = exception.first
        if ex.made_up_hours
          return true
        end
      end
      if user_met_build_hour_reqs(user) && user_met_build_meeting_reqs(user)
        return true
      else
        return false
      end
    end
  end
  def user_met_build_hour_reqs(user)
    time = get_users_hours_as_time(user)
    hours = time.hour + (time.day-1)*24
    minutes = time.min
    flex = get_users_flex_hours(user)

    if !flex.nil? and !flex.empty?
      flex.each do |flex_hour|
        minutes = minutes+(flex_hour.num_minutes)
      end
    end
    hours = hours + minutes/60.0
    logger.warn "hours: #{time.hour}"
    logger.warn "days: #{time.day-1}"
    logger.warn "total hours: #{hours.inspect}"
    if hours >= get_users_required_build_hours(user)
      return true
    else
      return false
    end
  end
  def hours_calc(user)
    time = get_users_hours_as_time(user)
    hours = time.hour + (time.day-1)*24
    minutes = time.min
    flex = get_users_flex_hours(user)

    if !flex.nil? and !flex.empty?
      flex.each do |flex_hour|
        minutes = minutes+(flex_hour.num_minutes)
      end
    end
    hours = hours + minutes/60.0
    return hours
  end
  def user_met_build_meeting_reqs(user)
    meetings_required = user.required_build_meetings
    if get_users_flex_hours(user).size >=1
      meetings_required = 0
    end

    if num_meetings_by_user(user)>=meetings_required
      return true
    else
      return false
    end
  end
  def get_users_required_build_hours(user)
    user_hours = user.required_build_hours
    
    exceptions = self.week_exceptions
		if !exceptions.empty?
			exceptions.order("date").each do |ex|
				return (user_hours*ex.weight).round(2)
			end
		end
    return user_hours
  end
  
  ##################### Helper Methods
  def get_users_hours_as_time(user)
    Time.at(self.get_users_hours(user)).utc
  end
  def get_users_hours(user)
    logs = user_logs(user)
    
		total = 0
		logs.each do |log|
		  total = total+log.time_logged
		end
    return total
  end
  def num_meetings_by_user(user)
    logs = user_logs(user)
    
    logs_grouped = logs.group_by{|a| a.timein.strftime("%m/%d/%Y")} rescue 0
    return logs_grouped.count rescue 0
  end 
  def user_logs(user)
    self.timelogs.where(:user_id=>user.id)
  end
  def get_users_hour_exceptions(user)
    self.hour_exceptions.where(:user_id=>user.id)
  end
  def get_users_flex_hours(user)
    self.flex_hours.where(:user_id=>user.id)
  end
end

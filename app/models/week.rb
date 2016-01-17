class Week < ActiveRecord::Base
  belongs_to :year
  has_many :hour_exceptions, dependent: :nullify
  has_many :week_exceptions, dependent: :nullify
  has_many :timelogs, dependent: :nullify
  
  
  scope :past, -> { where("year_id = ? AND week_start <= ?", Year.current_year, ApplicationHelper.today)}
  scope :summer, -> { where(:season=>"Summer")}
  scope :preseason, -> { where(:season=>"Preseason")}
  scope :build_season, -> { where(:season=>"Build Season")}
  
  def week_range
    "#{self.week_start.strftime("%m/%d/%Y") } - #{self.week_end.strftime("%m/%d/%Y") }"
  end
  def self.find_week(date)
    week = Week.where("week_start <= ? and week_end >= ?",date,date).first
  end
  def self.current_week
    week = Week.where("week_start <= ? and week_end >= ?",Date.today,Date.today).first
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
  ### Build Season Reqs #####
  def user_met_all_weekly_build_reqs(user)
    if user_met_build_hour_reqs(user) && user_met_build_meeting_reqs(user)
      return true
    else
      return false
    end
  end
  def user_met_build_hour_reqs(user)
    time = get_users_hours_as_time(user)
    hours = time.hour + time.day*24
    if hours >= get_users_required_build_hours(user)
      return true
    else
      return false
    end
  end
  def user_met_build_meeting_reqs(user)
    if num_meetings_by_user(user)>=Constants::BUILD_MEETINGS
      return true
    else
      return false
    end
  end
  def get_users_required_build_hours(user)
    user_hours = user.required_hours
    
    exceptions = self.week_exceptions
		if !exceptions.empty?
			exceptions.order("date").each do |ex|
				return (user_hours*ex.weight).round(2)
			end
		end
    return user_hours
  end
  ### PreSeason Reqs #####
  def user_met_all_weekly_pre_reqs(user)
    if user_met_build_meeting_reqs(user)
      return true
    else
      return false
    end
  end
  def user_met_pre_meeting_reqs(user)
    if num_meetings_by_user(user)>=Constants::PRE_MEETINGS
      return true
    else
      return false
    end
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
end

class User < ActiveRecord::Base
  before_save :lowercaseID
  before_save :encrypt_password
  before_save :clean_phone_number
  has_many :timelogs
  belongs_to :school
  has_and_belongs_to_many :forms
  has_many :forms_users
  has_many :years, :through=>:timelogs
  has_one :hour_override, -> {where(year_id: Year.current_year.id)}
  has_many :hour_exceptions, -> {where(year_id: Year.current_year.id)}

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :school, :school_id, :email, :password, :password_confirmation, :name_first, :name_last, :phone,:location, :admin, :userid, :archive, :form_id, :form_ids, :forms_user_id, :gender, :graduation_year, :student_leader
  # attr_accessible :title, :body
  attr_accessor :password
  
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :message=>"Please enter a valid email."
  validates_uniqueness_of :userid
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :userid
  validates_presence_of :gender
  validates_presence_of :location
  validates_uniqueness_of :email
  
  scope :archived, -> {where(:archive => true)}
  #scope :active, where("users.archive IS NOT 1") ##Change back for production!!!
  
  
  ###################### General Info ##########################
  def self.active
    where("users.archive IS NOT true")
  end
  def is_mentor
    if !self.school.nil? && self.school.name=="Mentor"
      return true
    end
    return false
  end
  def full_name
    return "#{self.name_first} #{self.name_last}"
  end
  def get_class
    if Year.current_year.nil?
      return "No year"
    end
    
    case
    when (Year.current_year.year_end.year + 3).to_s == self.graduation_year
      return "Freshman"
    when (Year.current_year.year_end.year + 2).to_s == self.graduation_year
      return "Sophomore"
    when (Year.current_year.year_end.year + 1).to_s == self.graduation_year
      return "Junior"
    when (Year.current_year.year_end.year).to_s == self.graduation_year
      return "Senior"
    end
  end
  ###################### END General Info ##########################
  ###################### Authentication ##########################
  def self.authenticate(email, password)
    #user = find_by_email(email)
    user = User.where(email: email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  def signed_in
    if self.timelogs.in_today.nil? || self.timelogs.in_today.empty?
      return false
    else
      return self.timelogs.in_today.first
    end
  end
  ###################### END Authentication ##########################
  ######################Yearly Totals##########################
  def years_build_hours(year)
    #Number of build season hours for the year
    total = 0
    self.timelogs.where("year_id = ? and timein >= ?",year.id, year.build_season_start).each do |log|
      total = total + log.time_logged
    end
    return total
  end
  def build_hours_formatted(seconds)
    #format the build season hours
    return User.format_time(years_build_hours(seconds))
  end
  def years_total_hours(year)
    total = 0
    self.timelogs.where(:year_id => year.id).each do |log|
        total = total + log.time_logged
    end
    total
  end
  def total_hours_formatted(seconds)
    return User.format_time(years_total_hours(seconds))
  end
  def self.allStudentsForYear(year)
    users = User.joins(:timelogs).where("timein >= ? and timein < ?",year.year_start,year.year_end)
    return users
  end
  def has_hours(year)
    logs = self.timelogs.where("timein >= ? and timein < ?",year.year_start,year.year_end)
    if logs.size > 0
      return true
    end
    return false
  end
  ###################### END Yearly Totals##########################
  ###################### Logging/Formatting ##########################
  def grouped_logs
    self.timelogs.order('timein asc').group_by{ |u| ApplicationHelper.toLocalTime(u.timein).beginning_of_week }
  end
  def self.format_time(total)
    time = Time.at(total).utc
    return "#{'%02d' % (time.hour + (time.day-1)*24)}:#{'%02d' % time.min}:#{'%02d' % time.sec}"
  end
  
  ###################### Requirements ##########################
  def met_build_season_reqs(date)
		if met_build_season_hours(date) && met_build_season_meetings(date)
			return true
		else
			return false
		end
  end
  def met_preseason_reqs(date)
    if met_preseason_meetings(date)
      return true
    else
      return false
    end
  end
  ###################### PreSeason ##########################
  def met_preseason_meetings(date)
    self.get_weeks_log_count(date)>=Constants::PRE_MEETINGS
  end
  ###################### End PreSeason ##########################
  ###################### Build Season ##########################
  def met_build_season_meetings(date)
    self.get_weeks_log_count(date)>=Constants::BUILD_MEETINGS
  end
  def met_build_season_hours(date)
		if self.get_weeks_hours_in_time(date).hour >= self.weekly_required_hours(date)
			return true
		else
			return false
		end
  end
  def weekly_required_hours(date)
    #Takes any day in the week
    exceptions = Year.current_year.week_exceptions.where("date >= ? and date <= ?",date.beginning_of_week,date.end_of_week).uniq
		if !exceptions.empty?
			exceptions.order("date").each do |ex|
				return (self.required_hours*ex.weight).round(2)
			end
		end
    return self.required_hours
  end
  def required_hours 
    if !self.hour_override.nil?
      return self.hour_override.hours_required
    end
    if self.student_leader
      return Constants::LEADERSHIP_HOURS
    end
    
    case self.get_class
    when "Freshman"
      return Constants::FRESHMAN_HOURS
    when "Sophomore"
      return Constants::SOPHOMORE_HOURS
    when "Junior"
      return Constants::JUNIOR_HOURS
    when "Senior"
      return Constants::SENIOR_HOURS
    end
    
    return 0
  end
  ###################### End Build Season ##########################
  ###################### Weekly Hour Calculations ##########################
  def get_weeks_hours(date)
    logs = self.get_weeks_logs(date)
		total = 0
		logs.each do |log|
		  total = total+log.time_logged
		end
    return total
  end
  def get_weeks_hours_in_time(date)
    Time.at(self.get_weeks_hours(date)).utc
  end
  def get_weeks_log_count(date)
    logs = self.get_weeks_logs(date)
		
    logs_grouped = logs.group_by{|a| a.timein.strftime("%m/%d/%Y")} rescue 0
    count = logs_grouped.count rescue 0
    return count
  end
  def get_weeks_logs(date)
    logs = self.timelogs.where("timein >= ? and timein <= ?",date.beginning_of_week,date.end_of_week)
    return logs
  end
  
  ###################### End Weekly Hour Calculations ##########################
  
  
  private 
    def lowercaseID
      self.userid = self.userid.downcase
    end
    def clean_phone_number
      self.phone = self.phone.gsub(/\D/, '')
    end
end

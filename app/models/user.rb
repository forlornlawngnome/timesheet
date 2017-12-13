class User < ActiveRecord::Base
  before_save :lowercaseID
  before_save :encrypt_password
  before_save :clean_phone_number
  has_many :timelogs
  belongs_to :school
  has_and_belongs_to_many :forms
  has_many :forms_users
  has_many :years, :through=>:timelogs
  has_one :hour_override, -> {where(year_id: Year.current_year.id)},  dependent: :destroy
  has_many :hour_exceptions, -> {where(year_id: Year.current_year.id)}, dependent: :destroy
  has_many :messages
  has_many :colleges

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
    where(:archive => false)
  end
  def is_mentor
    if !self.school.nil? && self.school.name=="Mentor"
      return true
    end
    return false
  end
  def is_default_user
    self.email == Constants::DEFAULT_LOGIN
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
    user = User.where("lower(email) like ?", email.downcase).first
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
    total=0
    year.weeks.build_season.each do |week|
      total=total+week.get_users_hours(self)
    end
    return total
  end
  def build_hours_formatted(year)
    #format the build season hours
    return User.format_time(years_build_hours(year))
  end
  def years_total_hours(year)
    total = 0
    year.weeks.each do |week|
      total=total+week.get_users_hours(self)
    end
    total
  end
  def total_hours_formatted(year)
    return User.format_time(years_total_hours(year))
  end
  def self.allStudentsForYear(year)
    users = User.joins(:timelogs).where("timein >= ? and timein < ?",year.year_start,year.year_end)
    return users
  end
  def has_hours(year)
    logs = self.timelogs.in_year(year)
    if logs.size > 0
      return true
    end
    return false
  end
  def years_preseason_hours(year)
    total = 0
    year.weeks.preseason.each do |week|
      total=total+week.get_users_hours(self)
    end
    return total
  end
  def pre_hours_formatted(year)
    #format the build season hours
    return User.format_time(years_preseason_hours(year))
  end
  def preseason_meetings
    #Number of pre season meetings for the year
    return past_preseason_meetings(Year.current_year)
  end
  def past_preseason_meetings(year)
    total = 0
    year.weeks.preseason.each do |week|
      total = total + week.num_meetings_by_user(self)
    end
    return total
  end
  ###################### END Yearly Totals##########################
  ###################### Logging/Formatting ##########################
  def self.format_time(total)
    time = Time.at(total).utc
    return "#{'%02d' % (time.hour + (time.day-1)*24)}:#{'%02d' % time.min}:#{'%02d' % time.sec}"
  end
  
  ###################### Requirements ##########################
  def all_forms_in
    users_forms = self.forms.map{|x| x.id}
    all_forms = Form.all_required.reject{|x| users_forms.include? x.id}
    if all_forms.empty?
      return true
    else
      return false
    end
  end
  def build_season_met
    year = Year.current_year
    weeks = year.weeks.past.build_season
    weeks.each do |week|
      if !week.met_weekly_reqs(self)
        return false
      end
    end
    return true
  end

  ###################### Build Season ##########################
  def required_build_meetings
    if !Year.current_year.requirement.nil?
      req=Year.current_year.requirement
      if req.build_meetings.nil?
        return 0
      else
        return req.build_meetings
      end
    else  
      return Constants::BUILD_MEETINGS
    end
  end
  def required_build_hours 
    if !self.hour_override.nil?
      return self.hour_override.hours_required
    end

    if !Year.current_year.requirement.nil?
      req=Year.current_year.requirement
      if self.student_leader
        if req.leadership_hours.nil?
          return 0
        else
          return req.leadership_hours
        end
      end
        
      case self.get_class
      when "Freshman"
        if req.freshman_hours.nil?
          return 0
        else
          return req.freshman_hours
        end
      when "Sophomore"
        if req.sophomore_hours.nil?
          return 0
        else
          return req.sophomore_hours
        end
      when "Junior"
         if req.junior_hours.nil?
          return 0
        else
          return req.junior_hours
        end
      when "Senior"
         if req.senior_hours.nil?
          return 0
        else
          return req.senior_hours
        end
      end
    else  
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
    end
   
    
    return 0
  end
  ###################### End Build Season ##########################
  
  
  private 
    def lowercaseID
      self.userid = self.userid.downcase
    end
    def clean_phone_number
      self.phone = self.phone.gsub(/\D/, '')
    end
end

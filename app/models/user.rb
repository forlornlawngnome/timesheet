class User < ActiveRecord::Base
  before_save :lowercaseID
  before_save :encrypt_password
  has_many :timelogs
  belongs_to :school
  has_and_belongs_to_many :forms
  has_many :forms_users
  has_many :years, :through=>:timelogs

  # Setup accessible (or protected) attributes for your model
  attr_accessible :school, :school_id, :email, :password, :password_confirmation, :name_first, :name_last, :phone,:location, :admin, :userid, :archive, :form_id, :form_ids, :forms_user_id, :gender, :graduation_year, :student_leader
  # attr_accessible :title, :body
  attr_accessor :password
  
  validates_uniqueness_of :userid
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  scope :archived, :conditions => {:archive => true}
  #scope :active, where("users.archive IS NOT 1") ##Change back for production!!!
  
  def required_hours 
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
  def self.active
    if Rails.env.production?
      where("users.archive IS NOT true")
    else
      where("users.archive IS NOT ?","t")
    end
  end
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  def is_mentor
    if !self.school.nil? && self.school.name=="Mentor"
      return true
    end
    return false
  end
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  def lowercaseID
    self.userid = self.userid.downcase
  end
  def signed_in
    if self.timelogs.in_today.nil? || self.timelogs.in_today.empty?
      return false
    else
      return self.timelogs.in_today.first
    end
  end
  def full_name
    return "#{self.name_first} #{self.name_last}"
  end
  def build_hours(year)
    total = 0
    self.timelogs.where("year_id = ? and timein >= ?",year.id, year.build_season_start).each do |log|
      total = total + log.time_logged
    end
    return total
  end
  def build_hours_formatted(seconds)
    return User.format_time(build_hours(seconds))
  end
  def total_hours(year)
    total = 0
    self.timelogs.where(:year_id => year.id).each do |log|
        total = total + log.time_logged
    end
    total
  end
  def total_hours_formatted(seconds)
    return User.format_time(total_hours(seconds))
  end
  def has_hours(year)
    logs = self.timelogs.where("timein >= ? and timein < ?",year.year_start,year.year_end)
    if logs.size > 0
      return true
    end
    return false
  end
  def grouped_logs
    self.timelogs.order('timein asc').group_by{ |u| ApplicationHelper.toLocalTime(u.timein).beginning_of_week }
  end
  def self.format_time(total)
    time = Time.at(total).utc
    return "#{'%02d' % (time.hour + (time.day-1)*24)}:#{'%02d' % time.min}:#{'%02d' % time.sec}"
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
end

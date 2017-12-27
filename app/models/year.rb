class Year < ActiveRecord::Base
  #attr_accessible :build_season_start, :year_end, :year_start
  
  has_many :timelogs
  has_many :users, :through => :timelogs
  has_many :hour_overrides
  has_many :hour_exceptions
  has_many :week_exceptions
  has_many :weeks, dependent: :delete_all
  has_one :requirement
  has_many :flex_hours, :through=>:weeks
  
  accepts_nested_attributes_for :weeks
  
  #before_create :setup_weeks
  before_save :update_weeks
  after_save :update_week_associated
  
  def is_current_year?
    if !Year.current_year.nil? && Year.current_year.id == self.id
      return true
    end
    return false
  end
  def self.current_year
    year = Year.where("year_start <= ? and year_end >= ?",Date.current,Date.current).first
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
  end
  def self.preseason_meetings_req
    if !Year.current_year.requirement.nil?
      req=Year.current_year.requirement
      if req.pre_meetings.nil?
        return 0
      else
        return req.pre_meetings
      end
    else  
      return Constants::PRE_MEETINGS
    end
  end
  def self.preseason_hours_req
    if !Year.current_year.requirement.nil?
      req=Year.current_year.requirement
      if req.pre_hours.nil?
        return 0
      else
        return req.pre_hours
      end
    else  
      return Constants::PRE_HOURS
    end
  end
  def self.max_flex_hours
    if !Year.current_year.requirement.nil?
      req=Year.current_year.requirement
      if req.max_flex_hours.nil?
        return 0
      else
        return req.max_flex_hours
      end
    else  
      return Constants::FLEX_HOURS
    end
  end
  private
    def setup_weeks
      #raise  (self.year_start..self.preseason_start).group_by{ |u| u.beginning_of_week}.inspect
      (self.year_start..self.preseason_start-1).group_by{ |u| u.beginning_of_week}.each do |date|
        self.weeks.build(:week_start=>date[1].first, :week_end=>date[1].last, :season=>"Summer")
      end
      (self.preseason_start..self.build_season_start-1).group_by{ |u| u.beginning_of_week}.each do |date|
        self.weeks.build(:week_start=>date[1].first, :week_end=>date[1].last, :season=>"Preseason")
      end
      (self.build_season_start..self.year_end).group_by{ |u| u.beginning_of_week}.each do |date|
        self.weeks.build(:week_start=>date[1].first, :week_end=>date[1].last, :season=>"Build Season")
      end

    end
    def update_weeks
      if !self.weeks.empty?
        self.weeks.destroy_all
      end
      setup_weeks
    end
    def update_week_associated
      update_hour_exceptions
      update_week_exceptions
      update_timelogs
    end
    def update_hour_exceptions
      exceptions = HourException.where(:week_id=>nil)
      exceptions.each do |ex|
        ex.save
      end
    end
    def update_week_exceptions
      exceptions = WeekException.where(:week_id=>nil)
      exceptions.each do |ex|
        ex.save
      end
    end
    def update_timelogs
      logs = Timelog.where(:week_id=>nil)
      logs.each do |log|
        log.save
      end
    end
end

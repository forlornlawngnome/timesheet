class HourException < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  belongs_to :week
  #attr_accessible :date_applicable, :date_sent, :reason, :submitter, :year, :year_id, :user, :user_id
  
  validates_uniqueness_of :user_id, :scope => :week
  
  before_save :setWeek
  before_save :setDateApplicable
  
  scope :in_range, -> (date_start, date_end){where("date_applicable >= ? and date_applicable <= ?",date_start,date_end)}
  scope :this_year, -> {where(:year_id => Year.current_year.id)}
  scope :build_season, -> {joins(:week).merge(Week.build_season)}
  
  def setWeek
    if self.week.nil?
      self.week = Week.find_week(self.date_applicable)
    end
  end
  def setDateApplicable
    if date_applicable.nil?  && !self.week.nil?
      self.date_applicable = self.week.week_start
    end
  end
end

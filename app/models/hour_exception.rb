class HourException < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  belongs_to :week
  #attr_accessible :date_applicable, :date_sent, :reason, :submitter, :year, :year_id, :user, :user_id
  
  validates_uniqueness_of :user_id, :scope => :date_applicable
  
  before_save :setWeek
  
  scope :in_range, -> (date_start, date_end){where("date_applicable >= ? and date_applicable <= ?",date_start,date_end)}
  scope :this_year, -> {where(:year_id => Year.current_year.id)}
  scope :build_season, -> {joins(:week).merge(Week.build_season)}
  
  def setWeek
    self.week = Week.find_week(self.date_applicable)
  end
end

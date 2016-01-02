class WeekException < ActiveRecord::Base
  belongs_to :year
  belongs_to :week
  #attr_accessible :date, :reason, :weight, :year, :year_id
  
  before_save :setWeek
  
  def setWeek
    self.week = Week.find_week(self.date)
  end
end

class Timelog < ActiveRecord::Base
  before_save :setTimeLogged
  before_save :setYear
  
  #attr_accessible :timein, :timeout, :user_id, :time_logged,  :year_id, :year_id, :updated_at
  belongs_to :user
  belongs_to :year
  
  validates :timein, :presence => true
  
  
  ##It views today as the current day UNLESS it is before 1am. If it is before 1am, then it defaults to the previous day as "today"
  scope :in_today, -> {where("timein >= ? AND timeout IS NULL",ApplicationHelper.today.utc)}
  scope :today, -> {where("timein >= ? and timein<= ?",ApplicationHelper.today.utc, ApplicationHelper.today.end_of_day.utc).order("updated_at DESC")}

  
  private
  def setTimeLogged
    if self.timeout.nil?
      self.time_logged = 60
    else
      self.time_logged = self.timeout - self.timein
    end
  end
  def setYear
    self.year = Year.find_year(self.timein)
  end
end

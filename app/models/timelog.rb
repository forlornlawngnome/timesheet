class Timelog < ActiveRecord::Base
  before_save :setTimeLogged
  
  belongs_to :user
  attr_accessible :timein, :timeout, :user_id, :time_logged, :updated_at
  
  
  ##It views today as the current day UNLESS it is before 1am. If it is before 1am, then it defaults to the previous day as "today"
  scope :in_today, where("timein >= ? AND timeout IS NULL",ApplicationHelper.today.utc)
  scope :today, where("timein >= ? ",ApplicationHelper.today.utc).order("updated_at DESC")

  
  private
  def setTimeLogged
    if self.timeout.nil?
      self.time_logged = 60
    else
      self.time_logged = self.timeout - self.timein
    end
  end
end

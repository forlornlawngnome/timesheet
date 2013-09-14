class Timelog < ActiveRecord::Base
  before_save :setTimeLogged
  
  belongs_to :user
  attr_accessible :timein, :timeout, :user_id, :time_logged, :updated_at
  
  scope :in_today, where("timein >= ? AND timeout IS NULL",Time.zone.now.beginning_of_day)
  scope :today, where("updated_at >= ? ",Time.zone.now.beginning_of_day).order("updated_at DESC")

  
  private
  def setTimeLogged
    if self.timeout.nil?
      self.time_logged = 60
    else
      self.time_logged = self.timeout - self.timein
    end
  end
end

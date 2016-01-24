class Message < ActiveRecord::Base
  belongs_to :user
  
  def status
    if self.color.nil? || self.color.empty?
      return "danger"
    else
      return self.color
    end
      
  end
end

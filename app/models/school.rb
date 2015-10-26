class School < ActiveRecord::Base
  #attr_accessible :name
  has_many :users
  
  def num_students(date)
    count = 0
    self.users.each do |user|
      if user.has_hours(date)
        count = count+1
      end
    end
    return count
  end
  def self.active_students
    if Rails.env.production?
      where("users.archive IS NOT true")
    else
      where("users.archive IS NOT ?","t")
    end
  end
end

class HourOverride < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  #attr_accessible :hours_required, :reason, :user, :user_id, :year, :year_id
  
  validates_uniqueness_of :user_id, :scope => :year_id
end

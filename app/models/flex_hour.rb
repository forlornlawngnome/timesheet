class FlexHour < ActiveRecord::Base
  belongs_to :user
  belongs_to :week
  has_one :year, :through=>:week
  has_one :requirement, :through => :year
  validate :hours_used_less_than_max

  def hours_used_less_than_max
  	hours_used = self.user.flex_hours.sum(:num_minutes)
	max = Constants::FLEX_HOURS
	if self.requirement
		max = self.requirement.max_flex_hours
	end
	if (max*60) < (hours_used + self.num_minutes)
  		errors.add(:num_minutes, "This would exceed your alloted flex time")
  	end
  end
end

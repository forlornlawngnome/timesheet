class WeekException < ActiveRecord::Base
  belongs_to :year
  attr_accessible :date, :reason, :weight, :year, :year_id
end

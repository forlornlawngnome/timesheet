class HourException < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  #attr_accessible :date_applicable, :date_sent, :reason, :submitter, :year, :year_id, :user, :user_id
  
  validates_uniqueness_of :user_id, :scope => :date_applicable
  
  scope :in_range, -> (date_start, date_end){where("date_applicable >= ? and date_applicable <= ?",date_start,date_end)}
end

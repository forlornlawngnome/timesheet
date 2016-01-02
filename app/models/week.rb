class Week < ActiveRecord::Base
  belongs_to :year
  has_many :hour_exceptions, dependent: :nullify
  has_many :week_exceptions, dependent: :nullify
  
  scope :summer, -> { where(:season=>"Summer")}
  scope :preseason, -> { where(:season=>"Preseason")}
  scope :build_season, -> { where(:season=>"Build Season")}
  
  def week_range
    "#{self.week_start.strftime("%m/%d/%Y") } - #{self.week_end.strftime("%m/%d/%Y") }"
  end
  def self.find_week(date)
    week = Week.where("week_start <= ? and week_end >= ?",date,date).first
  end
end

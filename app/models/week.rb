class Week < ActiveRecord::Base
  belongs_to :year
  
  scope :summer, -> { where(:season=>"Summer")}
  scope :preseason, -> { where(:season=>"Preseason")}
  scope :build_season, -> { where(:season=>"Build Season")}
end

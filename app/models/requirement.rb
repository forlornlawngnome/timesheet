class Requirement < ActiveRecord::Base
	belongs_to :year

	validates_uniqueness_of :year_id
	validates_presence_of :year_id
end

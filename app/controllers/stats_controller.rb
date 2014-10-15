class StatsController < ApplicationController
  def hours
    ismentor = School.where("lower(name) = ?","mentor").first
    @allHours = Hash.new{|h,k| h[k] = []}
    
    studentlogs = Timelog.where("timein >= ? ", ApplicationHelper.getStartDate).order("timein ASC")
    studentlogs = studentlogs.group_by{|a| a.timein.at_beginning_of_week}
    studentlogs.each do |log|
      studentsum=0
      mentorsum=0
      totalsum=0
      
      log[1].each do |timelog|
        totalsum = totalsum+timelog.time_logged
        
        if timelog.user.school == ismentor
          mentorsum = mentorsum + timelog.time_logged
        else
          studentsum = studentsum + timelog.time_logged
        end
      end
      
      studentsum=studentsum/(60*60) #Convert from seconds to hours for the graph
      mentorsum=mentorsum/(60*60) #Convert from seconds to hours for the graph
      totalsum=totalsum/(60*60) #Convert from seconds to hours for the graph
    
      @allHours[log[0].strftime("%m/%d/%Y")][0] = studentsum
      @allHours[log[0].strftime("%m/%d/%Y")][1] = mentorsum
      @allHours[log[0].strftime("%m/%d/%Y")][2] = totalsum
      
    end
    
  end
end

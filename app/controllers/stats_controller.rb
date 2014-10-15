class StatsController < ApplicationController
  def hours
    calculateHours1
    calculateHours2
    
    schoolArray
    @chartString = "['Date'"
    @schoolArray.each do |school|
      @chartString = "#{@chartString},'#{school}'" 
    end
    @chartString = "#{@chartString},'All'],".html_safe
  end
  def schoolArray
    @schoolArray = []
    School.order(:name).each do |school|
      @schoolArray.push(school.name)
    end
    @schoolArray.push("Other Students")
  end
  def calculateHours2
    ismentor = School.where("lower(name) = ?","mentor").first
    @allHoursSchools = Hash.new{|h,k| h[k] = {}}
    
    studentlogs = Timelog.where("timein >= ? ", ApplicationHelper.getStartDate).order("timein ASC")
    studentlogs = studentlogs.group_by{|a| a.timein.at_beginning_of_week}
    studentlogs.each do |log|
      totalsum=0
      
      schoolHours = Hash.new{|h,k| h[k] = []}
      schools = log[1].group_by{|a|a.user.school}

      schools.each do |school|
        sum=0
        school[1].each do |timelog|
          totalsum = totalsum+timelog.time_logged
          sum = sum + timelog.time_logged
        end
        
        sum=sum/(60*60) #Convert from seconds to hours for the graph
        schoolHours[school[0].name] << sum rescue schoolHours["Other Students"] << sum
      end
      totalsum=totalsum/(60*60) #Convert from seconds to hours for the graph
      
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["students"] = schoolHours
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["all"] = totalsum
    end
  end
  def calculateHours1
    ismentor = School.where("lower(name) = ?","mentor").first
    @allHours = Hash.new{|h,k| h[k] = []}
    overallHours = 0
    mentorHours = 0
    studentHours = 0
    
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
      
      studentHours = studentHours + studentsum
      mentorHours = mentorHours + mentorsum
      overallHours = overallHours + totalsum
    
      @allHours[log[0].strftime("%m/%d/%Y")][0] = studentsum
      @allHours[log[0].strftime("%m/%d/%Y")][1] = mentorsum
      @allHours[log[0].strftime("%m/%d/%Y")][2] = totalsum
      
      @allHours[log[0].strftime("%m/%d/%Y")][3] = studentHours
      @allHours[log[0].strftime("%m/%d/%Y")][4] = mentorHours
      @allHours[log[0].strftime("%m/%d/%Y")][5] = overallHours
      
      
    end
    
  end
end

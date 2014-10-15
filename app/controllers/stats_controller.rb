class StatsController < ApplicationController
  def hours
    if (!params[:year].nil? && ! params[:year].empty?)
      startDate = ApplicationHelper.getYearStart(params[:year].to_i)
    else
      startDate = ApplicationHelper.getStartDate
    end
    
    calculateHours1(startDate)
    
    schoolArray
    @chartString = "['Date'"
    @schoolArray.each do |school|
      @chartString = "#{@chartString},'#{school}'" 
    end
    @chartString = "#{@chartString},'All'],".html_safe
  end
  def schools
    @allSchools = Hash.new{|h,k| h[k] = {}}
    
    start = ApplicationHelper.getStartDate
    
    School.order(:name).each do |school|
      users = school.users.active
      @allSchools[school.name][0] = users.count
      
      totalHours = 0
      users.each do |user|
        totalHours = totalHours + user.total_hours_number(start)
      end
      totalHours = totalHours/(60*60)


      perStudentHours = totalHours/users.count rescue 0
     
      @allSchools[school.name][1] = totalHours
      @allSchools[school.name][2] = perStudentHours
    end
  end
  def schoolArray
    @schoolArray = []
    School.order(:name).each do |school|
      @schoolArray.push(school.name)
    end
    @schoolArray.push("Other Students")
  end
  def calculateHours1(start)
    ismentor = School.where("lower(name) = ?","mentor").first
    @allHours = Hash.new{|h,k| h[k] = []}
    @allHoursSchools = Hash.new{|h,k| h[k] = {}}
    
    overallHours = 0
    mentorHours = 0
    studentHours = 0
    
    studentlogs = Timelog.where("timein >= ? and timein < ?", start, start+1.year).order("timein ASC")
    studentlogs = studentlogs.group_by{|a| a.timein.at_beginning_of_week}
    studentlogs.each do |log|
      studentsum=0
      mentorsum=0
      totalsum=0

      log[1].each do |timelog|
        totalsum = totalsum+timelog.time_logged
        
        if !timelog.user.nil? && timelog.user.school == ismentor
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
      
      #Calculate hours per school
      totalsumper=0
      schoolHours = Hash.new{|h,k| h[k] = []}
      schools = log[1].group_by{|a|a.user.school rescue "Other School"}

      schools.each do |school|
        sum=0
        school[1].each do |timelog|
          totalsumper = totalsumper+timelog.time_logged
          sum = sum + timelog.time_logged
        end
        
        sum=sum/(60*60) #Convert from seconds to hours for the graph
        schoolHours[school[0].name] << sum rescue schoolHours["Other Students"] << sum
      end
      totalsumper=totalsumper/(60*60) #Convert from seconds to hours for the graph
      
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["students"] = schoolHours
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["all"] = totalsumper
      
    end
    
  end
end

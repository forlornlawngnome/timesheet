class StatsController < ApplicationController
  def hours
    if (!params[:year].nil? && ! params[:year].empty?)
      startDate = ApplicationHelper.getYearStart(params[:year].to_i)
    else
      startDate = ApplicationHelper.getStartDate
    end
    @startDate = startDate.year
    
    @range = ApplicationHelper.dateRange(startDate)
    calculateHours(startDate)
    
    schoolArray
    @chartString = "['Date'"
    @schoolArray.each do |school|
      @chartString = "#{@chartString},'#{school}'" 
    end
    @chartString = "#{@chartString}],".html_safe
  end
  def schools
    if (!params[:year].nil? && ! params[:year].empty?)
      startDate = ApplicationHelper.getYearStart(params[:year].to_i)
    else
      startDate = ApplicationHelper.getStartDate
    end
    @startDate = startDate.year
    
    @range = ApplicationHelper.dateRange(startDate)
    
    @allSchools = Hash.new{|h,k| h[k] = {}}
    
    start = startDate
    
    @totalStudents = 0
    
    School.joins(:users).active_students.uniq.order(:name).each do |school|
      users = school.users.active
      
      totalHours = 0
      count = 0
      users.each do |user|
        totalHours = totalHours + user.total_hours_number(start)
        if user.has_hours(start)
          count = count+1
        end
      end
      totalHours = totalHours/(60*60)

      @allSchools[school.name][0] = count
      @totalStudents = @totalStudents + count

      perStudentHours = totalHours/count rescue 0
     
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
  def calculateHours(start)
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
        if !school[0].nil? && !school[0].respond_to?(:to_str)
          schoolHours[school[0].name][0] = sum
          schoolHours[school[0].name][1] = sum/school[0].num_students(start)
        else
          schoolHours["Other Students"][0] = sum
          schoolHours["Other Students"][1] = calcNumber(start, sum)
        end
      end
      totalsumper=totalsumper/(60*60) #Convert from seconds to hours for the graph
      
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["students"] = schoolHours
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["all"] = totalsumper
      
    end
    
  end
  def calcNumber(start, sum)
    count = 0
    users = User.where("school_id IS NULL")
    users.each do |user|
      if user.has_hours(start)
        count = count+1
      end
    end
    if count == 0
      return 0
    end
    return sum/count
  end
end

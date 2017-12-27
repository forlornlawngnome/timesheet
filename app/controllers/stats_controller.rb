class StatsController < ApplicationController
  def hours
    if (!params[:year].nil? && ! params[:year].empty?)
      @selected_year = Year.find_by_id(params[:year])
    else
      @selected_year = Year.current_year
    end
    
    calculateHours(@selected_year)
    
    schoolArray
    @chartString = "['Date'"
    @schoolArray.each do |school|
      @chartString = "#{@chartString},'#{school}'" 
    end
    @chartString = "#{@chartString}],".html_safe
  end
  def schools
    if (!params[:year].nil? && ! params[:year].empty?)
      @selected_year = Year.find_by_id(params[:year])
    else
      @selected_year = Year.current_year
    end
    
    @range = @selected_year.year_range
    
    @allSchools = Hash.new{|h,k| h[k] = {}}
    
    @totalStudents = 0
    
    
    
    School.joins(:users).order(:name).uniq.each do |school|
      users = school.users
      
      totalHours = 0
      count = 0
      users.each do |user|
        totalHours = totalHours + user.years_total_hours(@selected_year)
        if user.has_hours(@selected_year)
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
  def gender
    if (!params[:year].nil? && ! params[:year].empty?)
      @selected_year = Year.find_by_id(params[:year])
    else
      @selected_year = Year.current_year
    end
    
    users = User.allStudentsForYear(@selected_year)
    @genderNumbers = users.group_by{|a| a.gender}

    
    #calculateHoursGender(@selected_year)
  end
  def schoolArray
    @schoolArray = []
    School.order(:name).each do |school|
      @schoolArray.push(school.name)
    end
    @schoolArray.push("Other Students")
  end
  def calculateHours(year)
    ismentor = School.where("lower(name) = ?","mentor").first
    @allHours = Hash.new{|h,k| h[k] = []}
    @allHoursSchools = Hash.new{|h,k| h[k] = {}}
    
    overallHours = 0
    mentorHours = 0
    studentHours = 0
    
    studentlogs = Timelog.where("timein >= ? and timein < ?", year.year_start, year.year_end).order("timein ASC")
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
          schoolHours[school[0].name][1] = sum/school[0].num_students(year)
        else
          schoolHours["Other Students"][0] = sum
          schoolHours["Other Students"][1] = calcNumber(year, sum)
        end
      end
      totalsumper=totalsumper/(60*60) #Convert from seconds to hours for the graph
      
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["students"] = schoolHours
      @allHoursSchools[log[0].strftime("%m/%d/%Y")]["all"] = totalsumper
      
    end
    
    ##Calculate the sum of hours per day of the week
    build_logs = Timelog.where("timein >= ? and timein < ?", year.year_start, year.year_end).order("timein ASC")
    hoursbyweek = build_logs.group_by{|a| a.timein.at_beginning_of_week}
    @monday = Array.new
    @tuesday = Array.new
    @wednesday = Array.new
    @thursday = Array.new
    @friday = Array.new
    @saturday = Array.new
    @sunday = Array.new
    
    hoursbyweek.each do |week|
      weeks_data = week[1]
      by_week = weeks_data.group_by{|a| a.timein.strftime("%A")}
      @monday.push(by_week['Monday'].nil? ? 0 : by_week['Monday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @tuesday.push(by_week['Tuesday'].nil? ? 0 : by_week['Tuesday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @wednesday.push(by_week['Wednesday'].nil? ? 0 : by_week['Wednesday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @thursday.push(by_week['Thursday'].nil? ? 0 : by_week['Thursday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @friday.push(by_week['Friday'].nil? ? 0 : by_week['Friday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @saturday.push(by_week['Saturday'].nil? ? 0 : by_week['Saturday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @sunday.push(by_week['Sunday'].nil? ? 0 : by_week['Sunday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
    end
    
  end
  def calculateHoursGender(year)
    ismentor = School.where("lower(name) = ?","mentor").first
    @allHours = Hash.new{|h,k| h[k] = []}
    
    overallHours = 0
    maleHours = 0
    femaleHours = 0
    otherHours = 0
    
    studentlogs = Timelog.where("timein >= ? and timein < ?", year.year_start, year.year_end).order("timein ASC")
    studentlogs = studentlogs.group_by{|a| a.timein.at_beginning_of_week}
    studentlogs.each do |log|
      malesum=0
      femalesum=0
      othersum=0
      totalsum=0

      log[1].each do |timelog|
        totalsum = totalsum+timelog.time_logged
        
        if !timelog.user.nil? && timelog.user.gender.downcase == "male"
          malesum = malesum + timelog.time_logged
        elsif !timelog.user.nil? && timelog.user.gender.downcase == "female"
          femalesum = femalesum + timelog.time_logged
        else
          othersum = othersum + timelog.time_logged
        end
      end
      
      
      malesum=malesum/(60*60) #Convert from seconds to hours for the graph
      femalesum=femalesum/(60*60) #Convert from seconds to hours for the graph
      othersum=othersum/(60*60) #Convert from seconds to hours for the graph
      totalsum=totalsum/(60*60) #Convert from seconds to hours for the graph
      
      maleHours = maleHours + malesum
      femaleHours = femaleHours + femalesum
      otherHours = otherHours + othersum
      overallHours = overallHours + totalsum
    
      @allHours[log[0].strftime("%m/%d/%Y")][0] = malesum
      @allHours[log[0].strftime("%m/%d/%Y")][1] = femalesum
      @allHours[log[0].strftime("%m/%d/%Y")][1] = othersum
      @allHours[log[0].strftime("%m/%d/%Y")][2] = totalsum
      
      @allHours[log[0].strftime("%m/%d/%Y")][3] = maleHours
      @allHours[log[0].strftime("%m/%d/%Y")][4] = femaleHours
      @allHours[log[0].strftime("%m/%d/%Y")][4] = otherHours
      @allHours[log[0].strftime("%m/%d/%Y")][5] = overallHours      
    end
    
    ##Calculate the sum of hours per day of the week
    build_logs = Timelog.where("timein >= ? and timein < ?", year.year_start, year.year_end).order("timein ASC")
    hoursbyweek = build_logs.group_by{|a| a.timein.at_beginning_of_week}
    @monday = Array.new
    @tuesday = Array.new
    @wednesday = Array.new
    @thursday = Array.new
    @friday = Array.new
    @saturday = Array.new
    @sunday = Array.new
    
    hoursbyweek.each do |week|
      weeks_data = week[1]
      by_week = weeks_data.group_by{|a| a.timein.strftime("%A")}
      @monday.push(by_week['Monday'].nil? ? 0 : by_week['Monday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @tuesday.push(by_week['Tuesday'].nil? ? 0 : by_week['Tuesday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @wednesday.push(by_week['Wednesday'].nil? ? 0 : by_week['Wednesday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @thursday.push(by_week['Thursday'].nil? ? 0 : by_week['Thursday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @friday.push(by_week['Friday'].nil? ? 0 : by_week['Friday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @saturday.push(by_week['Saturday'].nil? ? 0 : by_week['Saturday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
      @sunday.push(by_week['Sunday'].nil? ? 0 : by_week['Sunday'].map {|s| s['time_logged']}.reduce(0, :+)/(60*60))
    end
    
  end
  def calcNumber(year, sum)
    count = 0
    users = User.where("school_id IS NULL")
    users.each do |user|
      if user.has_hours(year)
        count = count+1
      end
    end
    if count == 0
      return 0
    end
    return sum/count
  end
end

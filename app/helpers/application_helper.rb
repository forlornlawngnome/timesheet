module ApplicationHelper
  def getWeeks
    if Date.today.month > 7
      start = DateTime.new(Date.today.year, 7, 1, 0, 0, 0)
    else
      start = DateTime.new(Date.today.year-1 , 7, 1, 0, 0, 0)
    end
    (start..Date.today).group_by{ |u| u.beginning_of_week }
  end
end

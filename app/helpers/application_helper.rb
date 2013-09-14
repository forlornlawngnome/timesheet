module ApplicationHelper
  def getWeeks
    start = DateTime.new(Date.today.year, 8, 1, 0, 0, 0)
    (start..Date.today).group_by{ |u| u.beginning_of_week }
  end
end

class AddMadeUpHoursToHourExceptions < ActiveRecord::Migration
  def change
    add_column :hour_exceptions, :made_up_hours, :boolean
  end
end

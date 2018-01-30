class AddMadeUpHoursToHourExceptions < ActiveRecord::Migration[5.1]
  def change
    add_column :hour_exceptions, :made_up_hours, :boolean
  end
end

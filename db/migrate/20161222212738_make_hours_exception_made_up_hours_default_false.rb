class MakeHoursExceptionMadeUpHoursDefaultFalse < ActiveRecord::Migration[5.1]
  def change
    HourException.where(made_up_hours: nil).update_all(made_up_hours: false)
    change_column :hour_exceptions, :made_up_hours, :boolean, null: false, default: false
  end
end

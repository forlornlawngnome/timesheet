class AddWeekToHourException < ActiveRecord::Migration[5.1]
  def change
    add_column :hour_exceptions, :week_id, :integer
  end
end

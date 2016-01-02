class AddWeekToHourException < ActiveRecord::Migration
  def change
    add_column :hour_exceptions, :week_id, :integer
  end
end

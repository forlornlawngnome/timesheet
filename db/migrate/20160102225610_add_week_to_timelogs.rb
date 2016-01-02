class AddWeekToTimelogs < ActiveRecord::Migration
  def change
    add_column :timelogs, :week_id, :integer
  end
end

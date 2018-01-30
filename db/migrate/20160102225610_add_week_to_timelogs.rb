class AddWeekToTimelogs < ActiveRecord::Migration[5.1]
  def change
    add_column :timelogs, :week_id, :integer
  end
end

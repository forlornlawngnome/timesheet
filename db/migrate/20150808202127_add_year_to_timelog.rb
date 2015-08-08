class AddYearToTimelog < ActiveRecord::Migration
  def change
    add_column :timelogs, :year_id, :integer
  end
end

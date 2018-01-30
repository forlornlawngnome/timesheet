class AddYearToTimelog < ActiveRecord::Migration[5.1]
  def change
    add_column :timelogs, :year_id, :integer
  end
end

class AddWeekToWeekException < ActiveRecord::Migration[5.1]
  def change
    add_column :week_exceptions, :week_id, :integer
  end
end

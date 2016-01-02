class AddWeekToWeekException < ActiveRecord::Migration
  def change
    add_column :week_exceptions, :week_id, :integer
  end
end

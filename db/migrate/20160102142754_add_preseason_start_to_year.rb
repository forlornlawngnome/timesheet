class AddPreseasonStartToYear < ActiveRecord::Migration
  def change
    add_column :years, :preseason_start, :date
  end
end

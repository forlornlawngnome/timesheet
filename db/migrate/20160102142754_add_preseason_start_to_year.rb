class AddPreseasonStartToYear < ActiveRecord::Migration[5.1]
  def change
    add_column :years, :preseason_start, :date
  end
end

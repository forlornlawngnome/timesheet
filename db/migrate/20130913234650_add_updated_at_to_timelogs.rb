class AddUpdatedAtToTimelogs < ActiveRecord::Migration
  def change
    add_column :timelogs, :updated_at, :timestamp
  end
end

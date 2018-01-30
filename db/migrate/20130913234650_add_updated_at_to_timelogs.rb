class AddUpdatedAtToTimelogs < ActiveRecord::Migration[5.1]
  def change
    add_column :timelogs, :updated_at, :timestamp
  end
end

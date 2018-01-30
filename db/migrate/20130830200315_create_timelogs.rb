class CreateTimelogs < ActiveRecord::Migration[5.1]
  def change
    create_table :timelogs do |t|
      t.references :user
      t.timestamp :timein
      t.timestamp :timeout
      t.integer :time_logged

    end
    #add_index :timelogs, :user_id
  end
end

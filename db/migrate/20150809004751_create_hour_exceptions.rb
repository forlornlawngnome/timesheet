class CreateHourExceptions < ActiveRecord::Migration[5.1]
  def change
    create_table :hour_exceptions do |t|
      t.references :user
      t.string :submitter
      t.date :date_applicable
      t.date :date_sent
      t.string :reason
      t.references :year

      t.timestamps
    end
    #add_index :hour_exceptions, :user_id
    #add_index :hour_exceptions, :year_id
  end
end

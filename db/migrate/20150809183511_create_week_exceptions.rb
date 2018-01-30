class CreateWeekExceptions < ActiveRecord::Migration[5.1]
  def change
    create_table :week_exceptions do |t|
      t.date :date
      t.decimal :weight
      t.text :reason
      t.references :year

      t.timestamps
    end
    #add_index :week_exceptions, :year_id
  end
end

class CreateWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :weeks do |t|
      t.date :week_start
      t.date :week_end
      t.string :season
      t.references :year, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

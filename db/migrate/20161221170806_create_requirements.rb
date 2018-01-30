class CreateRequirements < ActiveRecord::Migration[5.1]
  def change
    create_table :requirements do |t|
      t.integer :pre_meetings
      t.integer :pre_hours
      t.integer :build_meetings
      t.integer :freshman_hours
      t.integer :sophomore_hours
      t.integer :junior_hours
      t.integer :senior_hours
      t.integer :leadership_hours
      t.references :year, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

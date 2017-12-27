class CreateFlexHours < ActiveRecord::Migration[5.1]
  def change
    create_table :flex_hours do |t|
      t.references :user, index: true, foreign_key: true
      t.references :week, index: true, foreign_key: true
      t.text :reason
      t.integer :num_minutes

      t.timestamps null: false
    end
  end
end

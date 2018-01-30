class CreateHourOverrides < ActiveRecord::Migration[5.1]
  def change
    create_table :hour_overrides do |t|
      t.references :user
      t.references :year
      t.integer :hours_required
      t.text :reason

      t.timestamps
    end
    #add_index :hour_overrides, :user_id
    #add_index :hour_overrides, :year_id
  end
end

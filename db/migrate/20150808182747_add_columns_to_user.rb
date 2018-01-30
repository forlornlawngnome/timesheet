class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gender, :string
    add_column :users, :graduation_year, :string
    add_column :users, :student_leader, :boolean
  end
end

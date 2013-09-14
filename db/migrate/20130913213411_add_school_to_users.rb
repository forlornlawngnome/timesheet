class AddSchoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :school_id, :integer
    add_column :users, :tools, :boolean
    add_column :users, :conduct, :boolean
  end
end

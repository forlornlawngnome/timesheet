class AddSafetyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :basicSafety, :boolean
  end
end

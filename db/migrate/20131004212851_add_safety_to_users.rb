class AddSafetyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basicSafety, :boolean
  end
end

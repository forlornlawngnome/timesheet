class AddReadOnlyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :read_only, :boolean
    change_column :users, :read_only, :boolean, null: false, default: false
  end
end

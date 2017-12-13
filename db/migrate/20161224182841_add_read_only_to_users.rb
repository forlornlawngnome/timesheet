class AddReadOnlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :read_only, :boolean
    change_column :users, :read_only, :boolean, null: false, default: false
  end
end

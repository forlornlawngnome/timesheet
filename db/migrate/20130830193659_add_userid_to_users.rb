class AddUseridToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :userid, :string
  end
end

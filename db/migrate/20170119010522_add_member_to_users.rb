class AddMemberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :member, :boolean
  end
end

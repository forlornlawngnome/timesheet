class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :phone, :string
    add_column :users, :name_first, :string
    add_column :users, :name_last, :string
  end
end

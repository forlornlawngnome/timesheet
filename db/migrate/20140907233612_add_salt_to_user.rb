class AddSaltToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_salt, :string
    add_column :users, :password_hash, :string
  end
end

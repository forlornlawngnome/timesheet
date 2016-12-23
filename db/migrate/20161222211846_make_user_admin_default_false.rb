class MakeUserAdminDefaultFalse < ActiveRecord::Migration
  def change
    User.where(admin: nil).update_all(admin: false)
    change_column :users, :admin, :boolean, null: false, default: false
  end
end

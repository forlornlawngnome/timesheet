class MakeUserActiveDefaultFalse < ActiveRecord::Migration[5.1]
  User.where(archive: nil).update_all(archive: false)
  change_column :users, :archive, :boolean, null: false, default: false
end

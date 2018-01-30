class MakeFormsArchiveDefaultFalse < ActiveRecord::Migration[5.1]
  def change
    Form.where(archive: nil).update_all(archive: false)
    change_column :forms, :archive, :boolean, null: false, default: false
  end
end

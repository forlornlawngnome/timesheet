class MakeFormsRequiredDefaultFalse < ActiveRecord::Migration
  def change
    Form.where(required: nil).update_all(required: false)
    change_column :forms, :required, :boolean, null: false, default: false
  end
end

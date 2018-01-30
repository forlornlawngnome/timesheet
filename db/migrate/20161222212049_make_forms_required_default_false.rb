class MakeFormsRequiredDefaultFalse < ActiveRecord::Migration[5.1]
  def change
    Form.where(required: nil).update_all(required: false)
    change_column :forms, :required, :boolean, null: false, default: false
  end
end

class AddRequiredToForm < ActiveRecord::Migration[5.1]
  def change
    add_column :forms, :required, :boolean
  end
end

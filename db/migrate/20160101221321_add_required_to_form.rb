class AddRequiredToForm < ActiveRecord::Migration
  def change
    add_column :forms, :required, :boolean
  end
end

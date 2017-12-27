class AddMaxflexhoursToRequirements < ActiveRecord::Migration[5.1]
  def change
    add_column :requirements, :max_flex_hours, :integer
  end
end

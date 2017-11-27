class AddMaxflexhoursToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :max_flex_hours, :integer
  end
end

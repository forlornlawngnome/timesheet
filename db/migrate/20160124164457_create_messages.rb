class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true
      t.text :message
      t.string :color

      t.timestamps null: false
    end
  end
end

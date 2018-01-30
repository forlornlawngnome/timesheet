class CreateFormsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :forms_users do |t|
      t.references :user
      t.references :form
    end
    #add_index :forms_users, :user_id
    #add_index :forms_users, :form_id
  end
end

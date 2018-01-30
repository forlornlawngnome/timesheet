class ChangeHourExceptionReason < ActiveRecord::Migration[5.1]
  def change
  	change_column :hour_exceptions, :reason, :text
  end
end

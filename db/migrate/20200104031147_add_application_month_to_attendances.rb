class AddApplicationMonthToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application_month, :date
  end
end

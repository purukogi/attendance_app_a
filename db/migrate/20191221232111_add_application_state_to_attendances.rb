class AddApplicationStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application_state, :integer
  end
end

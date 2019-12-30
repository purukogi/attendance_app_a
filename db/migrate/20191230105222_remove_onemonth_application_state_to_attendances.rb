class RemoveOnemonthApplicationStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :onemonth_application_state, :integer
  end
end

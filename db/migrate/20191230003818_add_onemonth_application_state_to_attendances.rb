class AddOnemonthApplicationStateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :onemonth_application_state, :integer
  end
end

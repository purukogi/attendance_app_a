class AddOnemonthApplicationStateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :onemonth_application_state, :integer
  end
end

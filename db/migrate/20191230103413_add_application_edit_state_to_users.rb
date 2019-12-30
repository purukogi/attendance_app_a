class AddApplicationEditStateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :application_edit_state, :integer
  end
end

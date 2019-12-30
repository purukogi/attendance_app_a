class RemoveApplicationEditStateToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :application_edit_state, :integer
  end
end

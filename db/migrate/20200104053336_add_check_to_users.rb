class AddCheckToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :check, :boolean, default: false
  end
end

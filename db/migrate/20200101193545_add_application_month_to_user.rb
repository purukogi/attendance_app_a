class AddApplicationMonthToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :application_month, :date
  end
end

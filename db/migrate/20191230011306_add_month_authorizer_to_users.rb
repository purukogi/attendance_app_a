class AddMonthAuthorizerToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :month_authorizer, :integer
  end
end

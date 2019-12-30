class AddChangeAuthorizerToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :change_authorizer, :integer
  end
end

class RemoveChangeAuthorizerToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :change_authorizer, :integer
  end
end

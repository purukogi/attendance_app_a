class RemoveSuperiorFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :superior, :boolean
  end
end

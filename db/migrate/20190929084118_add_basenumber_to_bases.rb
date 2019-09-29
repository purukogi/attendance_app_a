class AddBasenumberToBases < ActiveRecord::Migration[5.1]
  def change
    add_column :bases, :basenumber, :integer
  end
end

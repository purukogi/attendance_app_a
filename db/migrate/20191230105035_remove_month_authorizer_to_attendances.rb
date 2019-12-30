class RemoveMonthAuthorizerToAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :month_authorizer, :integer
  end
end

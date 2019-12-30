class AddMonthAuthorizerToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_authorizer, :integer
  end
end

class AddStartedAt2ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at2, :datetime
  end
end

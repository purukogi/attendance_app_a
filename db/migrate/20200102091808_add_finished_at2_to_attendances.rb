class AddFinishedAt2ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :finished_at2, :datetime
  end
end

class AddNextDay2ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day2, :boolean
  end
end

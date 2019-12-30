class RemoveAttendanceCheckFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :attendance_check, :boolean, default: false
  end
end

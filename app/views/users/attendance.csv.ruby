require 'csv'

  bom = "\uFEFF"
  column_names = %w(日付 出社時間 退社時間 備考)
  CSV.generate(bom) do |csv|
  csv << column_names
  
  @attendances.each do |attendance|
  
  if attendance.started_at.nil? && attendance.finished_at.nil?
    column_values = [
      attendance.worked_on.strftime("%m/%d"),
      attendance.started_at,
      attendance.finished_at,
      attendance.note
    ]

   else
    column_values = [
      attendance.worked_on.strftime("%m/%d"),
      attendance.started_at.strftime('%H:%M'),
      attendance.finished_at.strftime('%H:%M'),
      attendance.note
    ]
  end
  
    csv << column_values  
  end
end
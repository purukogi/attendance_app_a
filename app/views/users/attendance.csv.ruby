require 'csv'

  bom = "\uFEFF"
  column_names = %w(日付 出社時間 退社時間 備考)
  CSV.generate(bom) do |csv|
  csv << column_names
  
  @attendances.each do |attendance|
  
    column_values = [
      attendance.worked_on.strftime("%m/%d"),
      attendance.started_at,
      attendance.finished_at,
      attendance.note
    ]
    csv << column_values  
  end
end
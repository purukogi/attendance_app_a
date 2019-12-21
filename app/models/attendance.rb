class Attendance < ApplicationRecord
  require 'rounding'
  belongs_to :user
  # 残業申請状態（0:無 1:申請中 2:承認 3:否認）
  enum application_state: { nothing: 0, applying: 1, approval: 2, denial: 3 }
  # 勤怠編集申請状態（0:無 1:申請中 2:承認 3:否認）
  enum application_edit_state: { nothing0: 0, applying1: 1, approval2: 2, denial3: 3 }

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効 ：カスタムバリデートを定義
  validate :finished_at_is_invalid_without_a_started_at
  
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効 ：カスタムバリデートを定義
  validate :started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_a_started_at #退勤時間のみ入力している場合のバリデート
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
end

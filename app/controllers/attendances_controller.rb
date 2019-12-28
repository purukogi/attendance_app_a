class AttendancesController < ApplicationController
  
  include AttendancesHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :admin_or_correct_user, only: [:edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month

  end

  
  def update_one_month
    @user = User.find(params[:id])
    if attendances_invalid?
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      end
      flash[:success] = "勤怠情報を更新しました。"
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
    end
  end
  
  def edit_overwork_request
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
    @youbi = %w{日 月 火 水 木 金 土}
  end
  
  def update_overwork_request
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
      if @attendance.update_attributes(overwork_request_params)
        flash[:success] = "残業を申請しました"
        redirect_to @user
      else
        flash[:danger] = "残業申請は失敗しました。"
        redirect_to @user
      end
  end
  
  def edit_overwork_approval
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
    @users = User.all
    # @users = User.joins(:attendances).where(attendances: { application_state: :applying })
    @youbi = %w{日 月 火 水 木 金 土}
    @applications_to_A = Attendance.where(authorizer_user_id: "上長Ａ", application_state: :applying)
    @applications_to_B = Attendance.where(authorizer_user_id: "上長Ｂ", application_state: :applying)
  end
  
  def update_overwork_approval
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
      if @attendance.update_attributes(overwork_request_params)
        flash[:success] = "残業を申請しました"
        redirect_to @user
      else
        flash[:danger] = "残業申請は失敗しました。"
        redirect_to @user
      end
  end
  
  private

    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :scheduled_end_time , :work_description])[:attendances]
    end
    
    def overwork_request_params
      params.require(:attendance).permit(:scheduled_end_time, :next_day, :work_description, :authorizer_user_id, :application_state)
    end

    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
end
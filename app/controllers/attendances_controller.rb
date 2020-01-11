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
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0), started_at2: Time.current.change(sec: 0))
        
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0), finished_at2: Time.current.change(sec: 0))
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
        attendance.update_attributes(item.permit(:next_day2))
        if attendance.next_day2 == true
          attendance.finished_at+1.day
        else
        end
        attendance.update_attributes(item)
      end
      flash[:success] = "勤怠情報を更新しました。"
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "出社時間、退社時間、上長選択のいずれかが未入力です"
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
        flash[:danger] = "上長の選択が未入力です"
        redirect_to @user
      end
  end
  
  def edit_overwork_approval
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
    # @users = User.joins(:attendances).where(attendances: { application_state: :applying })
    @youbi = %w{日 月 火 水 木 金 土}
    # 上長Ａあての残業申請を全て取得
    @applications_to_A = Attendance.where(authorizer_user_id: "上長Ａ", application_state: "申請中")
    # 名前ごとに分類
    @overwork_applicationsA = @applications_to_A.group_by do |application|
      User.find_by(id: application.user_id).name
    end
    
    # 上長Ｂあての残業申請を全て取得
    @applications_to_B = Attendance.where(authorizer_user_id: "上長Ｂ", application_state: "申請中")
    # 名前ごとに分類
    @overwork_applicationsB = @applications_to_B.group_by do |application|
      User.find_by(id: application.user_id).name
    end
  end
  
  def update_overwork_approval
    @user = User.find(params[:id])
    
    params[:application].each do |id, item|
    @attendance = Attendance.find(id)
    @attendance.update_attributes(item.permit(:check))
    
      if @attendance.check == true
        @attendance.update_attributes(item.permit(:application_state))
      elsif @attendance.check == false
        @attendance.update_attributes(item.permit(:check))
      end
    
    end
    
    flash[:success] = "勤怠変更申請を承認 or 否認しました。（※チェックボックスにチェックがついていない項目は反映されません）"
    redirect_to @user
  end
           
  def edit_changework_approval
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
    @youbi = %w{日 月 火 水 木 金 土}
    # 上長Ａあての勤怠申請を全て取得
    @applications_to_A = Attendance.where(change_authorizer: "上長A", application_edit_state: "なし　")
    # 名前ごとに分類
    @changework_applicationsA = @applications_to_A.group_by do |application|
    User.find_by(id: application.user_id).name
    end
    # 上長Ｂあての勤怠申請を全て取得
    @applications_to_B = Attendance.where(change_authorizer: "上長B", application_edit_state: "なし　")
    # 名前ごとに分類
    @changework_applicationsB = @applications_to_B.group_by do |application|
    User.find_by(id: application.user_id).name
    end
  end
  
  def update_changework_approval
    @user = User.find(params[:id])
      params[:application].each do |id, item|
      @attendance = Attendance.find(id)
      @attendance.update_attributes(item.permit(:check))
      
        if @attendance.check == true
          @attendance.update_attributes(item.permit(:application_edit_state))
        elsif @attendance.check == false
          @attendance.update_attributes(item.permit(:check))
        end
        
      end
    flash[:success] = "勤怠変更申請を承認 or 否認しました。（※チェックボックスにチェックがついていない項目は反映されません）"
    redirect_to @user
  end
  
  
  private

    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :started_at2, :finished_at, :finished_at2, :note, :change_authorizer, :application_edit_state, :next_day ,:next_day2])[:attendances]
    end
    
    def overwork_request_params
      params.require(:attendance).permit(:scheduled_end_time, :next_day, :work_description, :authorizer_user_id, :application_state)
    end
    
    def overwork_approval_params
      params.permit(:application_state)
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
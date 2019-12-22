class BasesController < ApplicationController
before_action :admin_user, only: [:index, :destroy, :base_info, :edit_base_info, :update_base_info]


  def index
    @bases = Base.all
  end
  
  def base_info
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点を追加しました。'
      redirect_to bases_url
    else
      redirect_to bases_url
    end
  end
  
   def destroy # 拠点を削除する際の処理
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "#拠点データを削除しました。"
    redirect_to bases_url
   end
  
  def edit_base_info
    @base = Base.find(params[:id])
  end
  
  def update_base_info
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = '拠点データを修正しました。'
      redirect_to bases_url
    end
  end
  
  private # strongparameterの設定

    def base_params
      params.require(:base).permit(:basenumber, :basename, :basetype)
    end
end

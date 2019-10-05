class BasesController < ApplicationController
before_action :admin_user, only: [:destroy, :base_info, :edit_base_info, :update_base_info]


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
    flash[:success] = "#拠点{@base.basename}のデータを削除しました。"
    redirect_to bases_url
   end
  
  def edit_base_info
  end
  
  def update_base_info
    @base = Base.find(params[:id])
    @base.update_attributes(base_params)
  end
  
  private # strongparameterの設定

    def base_params
      params.require(:base).permit(:basenumber, :basename, :basetype)
    end
end

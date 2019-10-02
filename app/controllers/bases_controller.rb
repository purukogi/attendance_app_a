class BasesController < ApplicationController
before_action :admin_user, only: [:destroy, :edit_base_info, :update_base_info]

  def index
    @bases = Base.all
  end
  
  def edit_base_info
    
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
  
  
  def update_base_info
    @base.update_attributes(base_params)
  end
  
  private # strongparameterの設定

    def base_params
      params.require(:base).permit(:basenumber,:basename, :basetype)
    end
end

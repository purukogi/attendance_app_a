Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # 出勤社員一覧
  get 'working_employee_list', to: 'users#working_employee_list'
  
  # 拠点
  get 'bases', to: 'bases#index'
  get 'base_info', to: 'bases#base_info'
  get 'edit_base_info', to: 'bases#edit_base_info'
  get '/new', to: 'bases#new'
  post '/new', to: 'bases#create'
  delete '/destroy', to: 'bases#destroy'
  patch '/update_base_info', to: 'bases#update_base_info'
 
  
  #リソース
  resources :users do
    collection { post :import }
  end
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      patch 'update_user_info'
      get 'attendances_edit_log'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      patch 'onemonth_apply'
      get 'onemonth_approval'
      patch 'update_onemonth_approval'
      # 勤怠確認ページ
      get 'check'
      # CSV出力
      get 'attendance'
    end
    resources :attendances do
      member do
        get 'edit_overwork_request'
        patch 'update_overwork_request'
        get 'edit_overwork_approval'
        patch 'update_overwork_approval'
        get 'edit_changework_approval'
        patch 'update_changework_approval'
      end
    end
  end
end

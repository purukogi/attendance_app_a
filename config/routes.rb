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
  post   '/new', to: 'bases#create'
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
      get 'attendances/edit_overwork_request'
      patch 'attendances/update_overwork_request'
      



    end
    resources :attendances, only: :update
  end
end

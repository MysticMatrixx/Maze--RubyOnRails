# frozen_string_literal: true

Rails.application.routes.draw do
  get 'search/index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'

  resources :posts do
    resources :comments
  end

  # resource :admin

  resource :likes, only: %i[create destroy]

  #VERB     URI PATTERN       CONTROLLER ACT        PREFIX           #
  get 'destroy/:id',  to: 'posts#destroy', as: 'delete_post',   method: :delete
  get 'posts/:id'   ,  to: 'posts#show'   , as: 'show_post'

  get 'search', to: 'search#index'

  # get 'destroy/:id/like', to: 'likes#destroy', as: 'delete_like'
  get 'likes/:id'  ,   to: 'likes#create',  as: 'delete_like', method: :delete

  # ADMIN ROUTES :
  get 'manage/users', to: 'admin#manage', as: 'admin_manager_menu'
  get 'manage/reports', to: 'admin#report', as: 'create_report'

  # USER IMPORT
  get 'manage/import/user', to: 'admin#import_page', as: 'upload_users_page'
  post 'importing/Users', to: 'admin#import_users', as: 'upload_users'

  # USER DATA EXPORTS
  get 'all_counts', to: 'admin#all_pcl_report', as: 'all_report'
  get 'all_limited_tens', to: 'admin#tenp_report', as: 'limited_report'
  get 'all_descripted', to: 'admin#postwise_report', as: 'descripted_report'

  # USER MANAGE_MENU, CREATE & DELETE :
  get 'manage/add/new_user', to: 'admin#new', as: 'admin_new_user'
  post 'create', to: 'admin#create', as: 'user_create'
  delete 'destroy/:id', to: 'admin#destroy', as: 'destroy_user'

  # EDIT USER DETAILS
  get 'edit/:id', to: 'admin#edit', as: 'edit_user'
  patch 'update/:id', to: 'admin#update', as: 'update_user'

  # EDIT USER PASSWORDS
  get 'update_password/user/:id', to: 'admin#change_password', as: 'edit_password_user'
  patch 'update_password/:id', to: 'admin#update_password', as: 'update_password_user'

  # USER STATUS
  devise_scope :user do
    get 'change_status/:id', to: 'users/sessions#change_status', as: 'change_status'
  end

  #     'update/:id'
  # get 'posts/:id' ,  to: 'posts#update' , as: 'update_post', method: :patch
  # not working as expected
end

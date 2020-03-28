Rails.application.routes.draw do
  resources :credits
  resources :genders
  resources :splits
  resources :availabilities
  resources :groups
  resources :group_invites
  resources :group_users
  resources :children


  devise_for :users,
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions"}
    #path_names: { sign_in: 'sign_in', sign_out: 'logout', sign_up: 'sign_up'}
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'landing#index'

  get 'dashboard', to: 'landing#dashboard', as: 'dashboard'
  get 'terms_of_service', to: 'landing#terms_of_service', as: 'terms_of_service'
  get 'faq', to: 'landing#faq', as: 'faq'
  get 'my_groups', to: 'groups#my_groups', as: 'my_groups'
  post 'request_split', to: 'splits#request_split', as: 'request_split'
  get 'approve_split/:id', to: 'splits#approve_split', as: 'approve_split'
  get 'decline_split/:id', to: 'splits#decline_split', as: 'decline_split'
  get 'cancel_split/:id', to: 'splits#cancel_split', as: 'cancel_split'
  get 'new_child_onboard', to: 'children#new_onboard', as: 'new_child_onboard'
  post 'create_children_onboard', to: 'children#create_children_onboard', as: 'create_children_onboard'
  get 'group_onboard', to: 'groups#group_onboard', as: 'group_onboard'
  post 'create_group_onboard', to: 'groups#create_group_onboard', as: 'create_group_onboard'
  get 'welcome', to: 'landing#welcome_new_user', as: 'welcome_new_user'
  post 'add_bulk_friends', to: 'group_invites#add_bulk_friends', as: 'add_bulk_friends'

  get 'new_user_onboard', to: 'users#new_user_onboard', as: 'new_user_onboard'
  get 'admin_dash', to: 'users#admin_dash', as: 'admin_dash'
  get 'profile/:id', to: 'users#profile', as: 'profile'
end

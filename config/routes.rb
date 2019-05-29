Rails.application.routes.draw do
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
  get 'profile/:id', to: 'landing#profile', as: 'profile'
  get 'my_groups', to: 'groups#my_groups', as: 'my_groups'
  get 'request_split/:availability_id', to: 'splits#request_split', as: 'request_split'
  get 'approve_split/:id', to: 'splits#approve_split', as: 'approve_split'
  get 'decline_split/:id', to: 'splits#decline_split', as: 'decline_split'
  get 'cancel_split/:id', to: 'splits#cancel_split', as: 'cancel_split'

end

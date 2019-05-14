Rails.application.routes.draw do
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

end

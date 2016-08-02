Rails.application.routes.draw do

  devise_for :residents, path_names: {
    sessions: 'residents/sessions',
    passwords: 'residents/passwords',
  }

  get 'pages/home'
  root 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

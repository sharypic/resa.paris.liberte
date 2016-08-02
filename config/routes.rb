Rails.application.routes.draw do

  devise_for :residents, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
  }

  get 'pages/home'
  root 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

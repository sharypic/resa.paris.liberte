Rails.application.routes.draw do
  devise_for :residents, path_names: {
    sessions: 'residents/sessions',
    passwords: 'residents/passwords'
  }

  root 'pages#home'

  resources :rooms, only: [:index], param: :slug do
    resources :calendars, only: [:index]
  end
end

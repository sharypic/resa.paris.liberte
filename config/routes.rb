Rails.application.routes.draw do
  # General routes
  segment_date = '/:year/:month/:day'
  constraints_date = { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }
  segment_datetime = "#{segment_date}/:hour/:minute"
  constraints_datetime = constraints_date.merge(hour: /\d{2}/, minute: /\d{2}/)

  # Authentication
  devise_for :residents, path_names: {
    sessions: 'residents/sessions',
    passwords: 'residents/passwords'
  }

  # Dev
  unless Rails.env.production?
    # mail
    get '/rails/mailers' => 'mailers_preview#index'
    get '/rails/mailers/*path' => 'mailers_preview#preview'

    # JS spec
    mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  end

  # Admin
  namespace :admin do
    resources :teams, except: [:show] do
      resources :time_account_lines, only: [:index, :create]

      resources :residents, except: [:show] do
        collection do
          get :index, as: :dated,
                      path: '/from/:from_year/:from_month/:from_day' \
                            '/to/:to_year/:to_month/:to_day'
        end
      end
      resources :reservations, only: [:index] do
        collection do
          get :index, as: :dated,
                      path: '/from/:from_year/:from_month/:from_day' \
                            '/to/:to_year/:to_month/:to_day'
        end
      end
    end
  end

  # Delayed job UI
  match '/delayed_job' => DelayedJobWeb, :anchor => false, via: [:get, :post]

  # App routes
  root 'pages#home'

  # Core of app is built around Rooms
  # A Resident can view rooms by type (:index)
  resources :rooms, only: [:index] do
    # A resident can view calendars of all Rooms by type
    collection do
      get :index, as: :dated,
                  path: "(#{segment_date})",
                  constraints: constraints_date

      resources :calendars, only: [:index],
                            as: :room_calendars,
                            path: ":room_slug/calendars#{segment_date}"
    end

    # A Resident can create a reservation for a specific Room
    resources :reservations, only: [:create, :show, :destroy] do
      collection do
        get :new, as: :new,
                  path: "/new#{segment_datetime}",
                  constraints: constraints_datetime
      end
    end
  end
end

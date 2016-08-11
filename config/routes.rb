Rails.application.routes.draw do
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


  # Delayed job UI
  match '/delayed_job' => DelayedJobWeb, :anchor => false, via: [:get, :post]

  # App routes
  root 'pages#home'
  # General routes
  segment_date = '/:year/:month/:day'
  segment_datetime = "#{segment_date}/:hour/:minute"

  # Core of app is built around Rooms
  # A Resident can view rooms by type (:index)
  resources :rooms, only: [:index] do
    # A resident can a calendars of all Rooms by type (:room_calendars)
    collection do
      get :index, path: "(#{segment_date})", as: :dated

      resources :calendars, only: [:index],
                            path: ":room_slug/calendars#{segment_date}",
                            as: :room_calendars
    end

    # A Resident can create a reservation for a specific Room
    resources :reservations, only: [:create] do
      collection do
        get :new, path: "/new#{segment_datetime}", as: :new
      end
    end
  end
end

Rails.application.routes.draw do
  root 'pages#home'

  # Authentication
  devise_for :residents, path_names: {
    sessions: 'residents/sessions',
    passwords: 'residents/passwords'
  }

  segment_date = '/:year/:month/:day'
  segment_datetime = "#{segment_date}/:hour/:minute"

  # Core of app is built around Rooms
  # A Resident can view rooms by type (:index)
  resources :rooms, only: [:index] do
    # A resident can a calendars of all Rooms by type (:room_calendars)
    collection do
      resources :calendars, only: [:index],
                            path: ":room_slug/calendars#{segment_date}",
                            as: :room_calendars
    end

  resources :rooms, only: [:index], param: :slug do
    resources :calendars, only: [:index]
  end
end

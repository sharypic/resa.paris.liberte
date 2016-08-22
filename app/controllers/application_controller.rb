class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :poc_authenticate_resident!
  before_action :detect_app

  def poc_authenticate_resident!
    sign_in(Resident.first)
  end

  def detect_app
    case request.user_agent
      when /IOS-app-turbolinks/i
        request.variant = :ios

      else
        request.variant = :desktop
    end
  end

  # Devise redirections
  def after_sign_in_path_for(_resource)
    rooms_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end
end

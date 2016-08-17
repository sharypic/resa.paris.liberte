# Fuck all those gem that build a custom admin. it's crud, code it, test it
module Admin
  # base controller for admin
  class ApplicationController < ActionController::Base
    before_action :authenticate_admin
    layout 'admin'

    def authenticate_admin
      unless resident_signed_in? && current_resident.admin?
        redirect_to(root_url)
      end
    end
  end
end

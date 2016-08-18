# Homepage
class PagesController < ApplicationController
  before_action :force_rooms_list_if_needed

  def home
  end

  private

  def force_rooms_list_if_needed
    redirect_to rooms_path if resident_signed_in?
  end
end

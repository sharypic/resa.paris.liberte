# frozen_string_literal: true
# Homepage
class PagesController < ApplicationController
  before_action :force_rooms_list_if_resident_signed_in?

  def home
  end

  private

  def force_rooms_list_if_resident_signed_in?
    redirect_to rooms_path if resident_signed_in?
  end
end

# List rooms available to book
class RoomsController < ApplicationController
  before_action :authenticate_resident!

  def index
    render locals: { date: Time.zone.today }
  end
end

# List rooms
class RoomsController < ApplicationController
  before_action :authenticate_resident!

  def index
  end
end

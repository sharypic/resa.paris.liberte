# List rooms available to book
class RoomsController < ApplicationController
  before_action :authenticate_resident!

  def index
  end
end

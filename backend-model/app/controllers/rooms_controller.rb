class RoomsController < ApplicationController
  def index
    @rooms = current_user.admin? ? Room.includes(:messages) : Room.includes(:messages).where(messages: {user: current_user} )
  end
end
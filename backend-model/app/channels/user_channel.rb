class UserChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    if current_user.admin?
      stream_from "room_and_messages_admin"
    else

      stream_from "room_and_messages#{current_user.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def fetch_room
    ActionCable.server.broadcast "room_and_messages#{current_user.id}", {kind: 'room_id', room_id: Room.find_or_create_by(creator_id: current_user.id ).id}
  end
end

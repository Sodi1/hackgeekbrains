class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload =  {kind: "new_message", object: render_message(message)}
    ActionCable.server.broadcast "room_and_messages#{message.room.creator_id}", payload
    ActionCable.server.broadcast "room_and_messages_admin", payload
  end
  private

  def render_message(message)
    JSON.parse! ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
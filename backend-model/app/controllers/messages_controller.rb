class MessagesController < ApplicationController
  def create
    room_id = if params[:room_id].nil?
      Room.create!(creator_id: current_user.id, name: text).id
              else
                params[:room_id]
                end
    @message = Message.create!(user: current_user, text: , room_id: )

    Room.find(room_id).update(human_need: true) if @message.text.downcase.match? /позови человека/

    LlmJob.perform_later(@message) unless @message.user.admin?
  end
  def index
    @messages = Message.where(room_id: params['room_id']).order(created_at: :desc).offset(offset).limit(limit)
  end

  private
  def text
    params.require(:text)
  end
    def room_id
      params[:room_id]
    end

  def offset
    params[:offset] || 0
  end

  def limit
    params[:limit] || 20
  end

end
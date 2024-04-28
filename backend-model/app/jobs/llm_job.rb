class LlmJob < ApplicationJob

  def perform(message)
    message.update(context: context(message.text))
    payload = {
      "messages": [{"role": message.user.admin? ? 'bot' : 'user', message: "#{message.text} ПРИМЕРЫ:#{message.context}"}]
    }
    Message.create(text: Llm.call(payload)['output'], room_id: message.room_id, user: User.find_or_create_by(name: "admin")  )
  end

  def context(text)
    qa = SemanticSearch.new.perform(text).first
    "Вопрос: #{qa.question} Ответ: #{qa.answer}"
  end
end
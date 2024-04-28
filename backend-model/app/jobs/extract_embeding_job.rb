class ExtractEmbedingJob < ApplicationJob

  retry_on Errno::ECONNREFUSED, wait: 5, attempts: Float::INFINITY
  def perform(answer_question_id)
    answer_question = AnswerQuestion.find(answer_question_id)

    answer_question.skip_embeding_update = true
    answer_question.update(question_embedding: TextEncoder.call(answer_question.question))
  end
end

class AnswerQuestion < ApplicationRecord
  default_scope -> { select(columns.map(&:name) - %w[search_index embedding]) }
  attr_accessor :skip_embeding_update

  after_save_commit -> (answer_question) { ExtractEmbedingJob.perform_later(answer_question.id) unless skip_embeding_update }
end

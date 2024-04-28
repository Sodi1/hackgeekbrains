class SemanticSearch
  def perform(query, exclude_extra: false)
    text_field = 'question'
    vector_field = 'question_embedding'
    fields = "id,answer,category,answer_class"
    where_extra = "WHERE extra=false"
    and_extra = "AND extra=false"
    sql = <<-SQL
      WITH semantic_search AS (
          SELECT #{fields}, #{text_field}, RANK () OVER (ORDER BY #{vector_field} <=> :embedding) AS rank
          FROM #{AnswerQuestion.quoted_table_name}
          #{where_extra if exclude_extra}
          ORDER BY #{vector_field} <=> :embedding
          LIMIT 100
      ),
      keyword_search AS (
          SELECT #{fields}, #{text_field}, RANK () OVER (ORDER BY ts_rank_cd(to_tsvector('english', #{text_field}), query) DESC)
          FROM #{AnswerQuestion.quoted_table_name}, plainto_tsquery('english', :query) query
          WHERE to_tsvector('english', #{text_field}) @@ query
          #{and_extra if exclude_extra}
          ORDER BY ts_rank_cd(to_tsvector('english', #{text_field}), query) DESC
          LIMIT 100
      )
      SELECT
          COALESCE(semantic_search.id, keyword_search.id) AS id,
          COALESCE(1.0 / (:k + semantic_search.rank), 0.0) +
          COALESCE(1.0 / (:k + keyword_search.rank), 0.0) AS score,
          COALESCE(semantic_search.answer, keyword_search.answer) as answer,
          COALESCE(semantic_search.category, keyword_search.category) as category,
          COALESCE(semantic_search.answer_class, keyword_search.answer_class) as answer_class,
          COALESCE(semantic_search.question, keyword_search.question) as question

      FROM semantic_search
      FULL OUTER JOIN keyword_search ON semantic_search.id = keyword_search.id
      ORDER BY score DESC
      LIMIT 20
    SQL
    return [] if query.blank?
    AnswerQuestion.find_by_sql([sql, { embedding: TextEncoder.call(query).to_s, query:, k: 60 }])
  end
end
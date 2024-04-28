class AnswerQuestionsController < ApplicationController


  def new;end
  def create
    file = params[:file_upload]
    csv = CSV.read(file)
    headers = csv.shift # ["Question", "Category", "Answer", "ans wer_class"]
    csv.each do |line|
      AnswerQuestion.create(question: line[0], category: line[1], answer: line[2], answer_class: line[3], extra: true)
    end
  end

  def upload_batch_search
    @submits = Submit.all.order(created_at: :desc)
  end

  def batch_search
    file = params[:file_upload]
    csv = CSV.read(file)
    headers = csv.shift # answer_class,Answer,Question,Category
    headers.concat ['top1', 'top10', 'top20']
    csv.map do |line|
      answer_questions = SemanticSearch.new.perform(line[2], exclude_extra: true)
      line.push answer_questions[0].answer_class
      line.push answer_questions[0..10].group_by { |e| e }.max_by { |k, v| v.size }&.first&.answer_class
      line.push answer_questions.group_by { |e| e }.max_by { |k, v| v.size }&.first&.answer_class
      line
    end
    # Define a file path for the output

    # Generate and save the CSV file
    csv_string = generate_csv(headers, csv)
    Submit.create(file_content: csv_string )
    redirect_to upload_batch_search_answer_questions_path
  end
  def index
    @answer_questions = SemanticSearch.new.perform(query)
  end

  def query
    params[:query]
  end

  private
  def generate_csv(headers, rows)
    CSV.generate do |csv|
      csv << headers  # Add headers at the top of the CSV
      rows.each { |row| csv << row }  # Append each row's fields to the CSV
    end
  end

end

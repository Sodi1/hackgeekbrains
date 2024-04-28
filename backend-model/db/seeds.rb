# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

puts "Creating initial data"
csv = CSV.read("public/answer_question_corpus.csv")
headers = csv.shift # ["Question", "Category", "Answer", "answer_class"]
csv.each do |line|
  AnswerQuestion.create(question: line[0], category: line[1], answer: line[2], answer_class: line[3])
end

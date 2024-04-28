# Второй пилот GeekBrains

## Запуск
```bash
docker-compose down && docker-compose up
```
## Основные пути
- [Админка](https://copilot-api.kovalev.team/admin)
- [Классификация вопросов](https://copilot-api.kovalev.team/answer_questions)
- [Загрузка корпуса вопросов](https://copilot-api.kovalev.team/answer_questions/new)
- [Сабмит](https://copilot-api.kovalev.team/answer_questions/upload_batch_search)
## Определение категории

1. для определения категории мы сгенерировали [корпус](public/answer_question_corpus.csv) из 7000 вопросов и ответов на основе существуюих данных. 
2. взяли эмединги от ответов моделью [Labse](https://huggingface.co/cointegrated/LaBSE-en-ru).
3. Далее на основе вопроса пользователя мы выполняем [гибридный поиск](app/models/semantic_search.rb) и таким образом определяем класс вопроса пользователя

## чатбот

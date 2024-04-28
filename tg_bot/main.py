import logging

import httpx
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import CommandHandler, Filters, MessageHandler, Updater

# Настройка логирования
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)
logger = logging.getLogger(__name__)

# ID администратора бота или специалиста поддержки
# TODO: добавить разделение на нескольких профильных спецов
admin_id = "ADMIN_ID"

# URL сервера для получения ответов
server_url = "https://copilot.kovalev.team/tg-chat"


def start(update: Update, context):
    update.message.reply_text("Здравствуйте! Просто задайте мне вопрос и я вам помогу.")


def answer_question(update: Update, context):
    question = update.message.text
    user_name = update.effective_user.name
    user_id = update.effective_user.id

    keyboard = [
        [
            # TODO: экранирование вопроса
            InlineKeyboardButton(
                "Перейти в чат",
                url=f"{server_url}?use_id={user_id}&username={user_name}&message={question}",
            ),
        ]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    update.message.reply_text(
        "Вашим вопросом уже занимается специалист. "
        "Для продолжения перейдите по ссылке ниже.",
        reply_markup=reply_markup,
    )


# def admin_reply(update: Update, context):
#     # Получаем ID пользователя из replied сообщения
#     user_id = update.message.reply_to_message.text.split()[1]
#     answer = update.message.text

#     # Отправляем ответ пользователю
#     context.bot.send_message(
#         chat_id=user_id, text=f"Специалист ответил на ваш вопрос: {answer}"
#     )


def main():
    # Создаем Updater и передаем ему токен бота
    updater = Updater(token='TOKEN', use_context=True)

    # Получаем диспетчер для регистрации обработчиков
    dispatcher = updater.dispatcher

    # Регистрируем обработчики команд
    dispatcher.add_handler(CommandHandler("start", start))

    # Регистрируем обработчики сообщений
    dispatcher.add_handler(
        MessageHandler(Filters.text & ~Filters.command, answer_question)
    )
    # dispatcher.add_handler(
    #     MessageHandler(Filters.reply & Filters.user(user_id=int(admin_id)), admin_reply)
    # )

    # Запускаем бота
    updater.start_polling()
    updater.idle()


if __name__ == "__main__":
    main()

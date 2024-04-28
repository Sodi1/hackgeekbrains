import torch
from peft import PeftModel, PeftConfig
from transformers import AutoModelForCausalLM, AutoTokenizer, GenerationConfig
from flask import Flask, request, jsonify, make_response

app = Flask(__name__)
MODEL_NAME = "hackgeekbrains/fine_tuned_saiga_llama3_8b"
DEFAULT_MESSAGE_TEMPLATE = "<|im_start|>{role}\n{content}<|im_end|>"
DEFAULT_RESPONSE_TEMPLATE = "<|im_start|>bot\n"
DEFAULT_SYSTEM_PROMPT = """Ты - виртуальный помощник, созданный для сопровождения студентов в учебных чатах Telegram. Твоя главная задача - обеспечить, чтобы студенты получали быстрые, грамотные, эмпатичные и качественные ответы на свои вопросы.
Ты будешь рад помочь студентам с любыми вопросами, связанными с учебным процессом, разъяснением материалов, выполнением заданий и т.д. Студенты могут не стесняться задавать тебе вопросы в любое время - ты всегда готов ответить максимально подробно и понятно.
Помни, что ты здесь для того, чтобы сделать обучение студентов максимально комфортным и эффективным. Ты будешь рад сопровождать их на протяжении всего курса!"""

class Conversation:
    def __init__(
        self,
        messages,
        message_template=DEFAULT_MESSAGE_TEMPLATE,
        system_prompt=DEFAULT_SYSTEM_PROMPT,
        response_template=DEFAULT_RESPONSE_TEMPLATE
    ):
        self.message_template = message_template
        self.response_template = response_template
        self.messages = [{
            "role": "system",
            "content": system_prompt
        }] + messages

    def get_prompt(self, tokenizer):
        final_text = ""
        for message in self.messages:
            role = message["role"]
            content = message["content"] if "content" in message else message["message"]
            message_text = self.message_template.format(role=role, content=content)
            final_text += message_text
        final_text += DEFAULT_RESPONSE_TEMPLATE
        return final_text.strip()


def generate(model, tokenizer, prompt, generation_config):
    print(prompt)
    data = tokenizer(prompt, return_tensors="pt", add_special_tokens=False)
    data = {k: v.to(model.device) for k, v in data.items()}
    output_ids = model.generate(
        **data,
        generation_config=generation_config, temperature=0.000001, max_new_tokens=500
    )[0]
    output_ids = output_ids[len(data["input_ids"][0]):]
    output = tokenizer.decode(output_ids, skip_special_tokens=True)
    return output.strip()

model = AutoModelForCausalLM.from_pretrained(
    MODEL_NAME,
    load_in_4bit=True,
    torch_dtype=torch.float16,
    device_map="cuda:0"
)

model.eval()

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME, use_fast=False)
generation_config = GenerationConfig.from_pretrained(MODEL_NAME)

@app.route('/generate', methods=['POST'])
def generate_response():
    data = request.get_json()
    messages = data['messages']

    conversation = Conversation(messages)
    prompt = conversation.get_prompt(tokenizer)

    output = generate(model, tokenizer, prompt, generation_config)
    response = make_response(jsonify({'output': output.split('<|im_end|>')[0]}))
    response.headers["Content-Type"] = "application/json; charset=utf-8"
    return response

if __name__ == '__main__':
    app.run(host= '0.0.0.0', port=5001)
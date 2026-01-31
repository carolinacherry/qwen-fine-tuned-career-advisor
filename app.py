"""
Career Advisor - Gradio Web UI

A simple chat interface for the fine-tuned career advice model.
"""

import gradio as gr
from mlx_lm import load, generate

# Load model globally for efficiency
print("Loading fine-tuned career advisor model...")
model, tokenizer = load(
    "Qwen/Qwen2.5-3B-Instruct",
    adapter_path="lora_adapters"
)
print("Model loaded!")

def get_career_advice(question: str, history: list) -> str:
    """Generate career advice for a given question."""
    if not question.strip():
        return "Please ask a career-related question."

    # Build conversation with chat template
    messages = [{"role": "user", "content": question}]
    prompt = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True
    )

    # Generate response
    response = generate(
        model,
        tokenizer,
        prompt=prompt,
        max_tokens=512
    )

    return response

# Example questions for users to try
EXAMPLES = [
    "Should I accept a counteroffer from my current employer?",
    "How do I negotiate a higher salary?",
    "I've been passed over for promotion twice. What should I do?",
    "Should I join a FAANG company or a startup?",
    "I'm burned out. Should I quit without another job lined up?",
    "How do I prepare for FAANG technical interviews?",
    "My manager is terrible but I like my team. Should I stay?",
    "I'm on a PIP. What should I do?",
    "Is a master's degree worth it in tech?",
    "How do I know if it's time to leave my job?",
]

# Create the Gradio interface
with gr.Blocks(
    title="Career Advisor",
    theme=gr.themes.Soft()
) as demo:
    gr.Markdown("""
    # 💼 Career Advisor

    **Direct, opinionated career advice** — no "it depends" hedging.

    This model has been fine-tuned on real industry knowledge to give you
    actionable career advice. Think Blind/levels.fyi energy, but actually helpful.

    ---
    """)

    chatbot = gr.Chatbot(
        label="Career Advice",
        height=400,
        show_copy_button=True
    )

    with gr.Row():
        question = gr.Textbox(
            label="Your Question",
            placeholder="Ask any career question... (e.g., 'Should I accept a counteroffer?')",
            scale=4
        )
        submit_btn = gr.Button("Get Advice", variant="primary", scale=1)

    gr.Markdown("### Try these examples:")
    examples = gr.Examples(
        examples=[[ex] for ex in EXAMPLES],
        inputs=[question],
        label=""
    )

    def respond(question, history):
        if not question.strip():
            return history, ""
        response = get_career_advice(question, history)
        history = history + [(question, response)]
        return history, ""

    submit_btn.click(
        respond,
        inputs=[question, chatbot],
        outputs=[chatbot, question]
    )

    question.submit(
        respond,
        inputs=[question, chatbot],
        outputs=[chatbot, question]
    )

    gr.Markdown("""
    ---

    **Note:** This is an experimental AI model. Career advice should be evaluated
    critically and adapted to your specific situation. The model's opinions are
    strong but not infallible.

    Built with [MLX](https://github.com/ml-explore/mlx) and
    [Gradio](https://gradio.app) on Apple Silicon.
    """)

if __name__ == "__main__":
    demo.launch(
        server_name="0.0.0.0",
        server_port=7860,
        share=False
    )

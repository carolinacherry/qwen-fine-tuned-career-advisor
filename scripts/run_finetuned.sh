#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Running Fine-tuned Model ==="
echo ""

# Check for eval questions
if [ ! -f "$PROJECT_DIR/eval_questions.json" ]; then
    echo "ERROR: eval_questions.json not found"
    exit 1
fi

# Check for LoRA adapters
if [ ! -d "$PROJECT_DIR/lora_adapters" ]; then
    echo "ERROR: lora_adapters directory not found"
    echo "Please run ./scripts/finetune.sh first"
    exit 1
fi

# Create outputs directory
mkdir -p "$PROJECT_DIR/outputs"

# Activate virtual environment
if [ -d "$PROJECT_DIR/venv" ]; then
    source "$PROJECT_DIR/venv/bin/activate"
else
    echo "ERROR: Virtual environment not found. Run setup.sh first."
    exit 1
fi

echo "Running fine-tuned Qwen2.5-7B on evaluation questions..."
echo ""

# Python script to run finetuned evaluation
python3 << 'EOF'
import json
from mlx_lm import load, generate

# Load eval questions
with open('eval_questions.json', 'r') as f:
    eval_data = json.load(f)

print("Loading fine-tuned model...")
model, tokenizer = load(
    "Qwen/Qwen2.5-7B-Instruct",
    adapter_path="lora_adapters"
)

results = []

for i, item in enumerate(eval_data['questions'], 1):
    question = item['question']
    print(f"[{i}/{len(eval_data['questions'])}] {question[:60]}...")

    prompt = f"You are a career advisor. Answer this question directly and concisely:\n\n{question}"

    try:
        response = generate(
            model,
            tokenizer,
            prompt=prompt,
            max_tokens=512,
            temp=0.7
        )
    except Exception as e:
        response = f"ERROR: {str(e)}"

    results.append({
        'question': question,
        'response': response,
        'scoring_criteria': item.get('scoring_criteria', {}),
        'expected_points': item.get('expected_points', [])
    })

# Save results
with open('outputs/finetuned_responses.json', 'w') as f:
    json.dump({
        'model': 'qwen2.5:7b',
        'type': 'finetuned',
        'adapter': 'lora_adapters',
        'results': results
    }, f, indent=2)

print(f"\n✓ Saved {len(results)} responses to outputs/finetuned_responses.json")
EOF

echo ""
echo "=== Fine-tuned Evaluation Complete ==="
echo ""
echo "Compare results:"
echo "  - outputs/baseline_responses.json"
echo "  - outputs/finetuned_responses.json"

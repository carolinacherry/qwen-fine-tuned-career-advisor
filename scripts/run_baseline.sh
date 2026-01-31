#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Running Baseline Model ==="
echo ""

# Check for eval questions
if [ ! -f "$PROJECT_DIR/eval_questions.json" ]; then
    echo "ERROR: eval_questions.json not found"
    exit 1
fi

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama service..."
    ollama serve &
    sleep 3
fi

# Create outputs directory
mkdir -p "$PROJECT_DIR/outputs"

# Activate virtual environment
if [ -d "$PROJECT_DIR/venv" ]; then
    source "$PROJECT_DIR/venv/bin/activate"
fi

echo "Running base Qwen2.5-3B on evaluation questions..."
echo ""

# Change to project directory for relative paths
cd "$PROJECT_DIR"

# Python script to run baseline evaluation
python3 << 'EOF'
import json
import subprocess
import sys

# Load eval questions
with open('eval_questions.json', 'r') as f:
    eval_data = json.load(f)

results = []

for i, item in enumerate(eval_data['questions'], 1):
    question = item['question']
    print(f"[{i}/{len(eval_data['questions'])}] {question[:60]}...")

    # Run through Ollama
    prompt = f"You are a career advisor. Answer this question directly and concisely:\n\n{question}"

    try:
        result = subprocess.run(
            ['ollama', 'run', 'qwen2.5:3b', prompt],
            capture_output=True,
            text=True,
            timeout=120
        )
        response = result.stdout.strip()
    except subprocess.TimeoutExpired:
        response = "ERROR: Response timed out"
    except Exception as e:
        response = f"ERROR: {str(e)}"

    results.append({
        'question': question,
        'response': response,
        'scoring_criteria': item.get('scoring_criteria', {}),
        'expected_points': item.get('expected_points', [])
    })

# Save results
with open('outputs/baseline_responses.json', 'w') as f:
    json.dump({'model': 'qwen2.5:3b', 'type': 'baseline', 'results': results}, f, indent=2)

print(f"\n✓ Saved {len(results)} responses to outputs/baseline_responses.json")
EOF

echo ""
echo "=== Baseline Evaluation Complete ==="

#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Career Advisor Fine-tuning ==="
echo ""

# Check for training data
if [ ! -f "$PROJECT_DIR/training_data.jsonl" ]; then
    echo "ERROR: training_data.jsonl not found"
    echo "Please ensure the training data file exists in the project root"
    exit 1
fi
echo "✓ Training data found"

# Count training examples
NUM_EXAMPLES=$(wc -l < "$PROJECT_DIR/training_data.jsonl" | tr -d ' ')
echo "✓ Found $NUM_EXAMPLES training examples"

# Activate virtual environment
if [ -d "$PROJECT_DIR/venv" ]; then
    source "$PROJECT_DIR/venv/bin/activate"
else
    echo "ERROR: Virtual environment not found. Run setup.sh first."
    exit 1
fi

# Create adapters directory
mkdir -p "$PROJECT_DIR/lora_adapters"

echo ""
echo "Starting LoRA fine-tuning..."
echo "This will take some time depending on your hardware."
echo ""

# Run LoRA fine-tuning with mlx-lm
# Parameters optimized for M4 Mac Mini with 16GB+ RAM
python -m mlx_lm.lora \
    --model Qwen/Qwen2.5-7B-Instruct \
    --data "$PROJECT_DIR" \
    --train \
    --iters 1000 \
    --batch-size 4 \
    --lora-layers 16 \
    --learning-rate 1e-5 \
    --adapter-path "$PROJECT_DIR/lora_adapters"

echo ""
echo "=== Fine-tuning Complete ==="
echo ""
echo "LoRA adapters saved to: $PROJECT_DIR/lora_adapters"
echo ""
echo "Next steps:"
echo "  Run ./scripts/run_finetuned.sh to test the fine-tuned model"

#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Career Advisor Fine-tuning ==="
echo ""

# Check for training data
if [ ! -f "$PROJECT_DIR/data/train.jsonl" ]; then
    echo "ERROR: data/train.jsonl not found"
    echo "Please ensure the training data file exists in the data directory"
    exit 1
fi
echo "✓ Training data found"

# Count training examples
NUM_TRAIN=$(wc -l < "$PROJECT_DIR/data/train.jsonl" | tr -d ' ')
NUM_VALID=$(wc -l < "$PROJECT_DIR/data/valid.jsonl" | tr -d ' ')
echo "✓ Found $NUM_TRAIN training examples"
echo "✓ Found $NUM_VALID validation examples"

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
echo "Model: Qwen/Qwen2.5-3B-Instruct"
echo "This will take some time depending on your hardware."
echo ""

# Run LoRA fine-tuning with mlx-lm
# Parameters optimized for Mac Mini M4 with 16GB RAM
# Improved settings for better quality:
# - 2000 iterations for more training
# - 8 LoRA layers (16 causes OOM on 16GB)
# - LoRA rank 16 for better capacity
# - Slightly higher learning rate
python -m mlx_lm.lora \
    --model Qwen/Qwen2.5-3B-Instruct \
    --data "$PROJECT_DIR/data" \
    --train \
    --iters 2000 \
    --batch-size 1 \
    --num-layers 8 \
    --lora-rank 16 \
    --learning-rate 2e-5 \
    --adapter-path "$PROJECT_DIR/lora_adapters"

echo ""
echo "=== Fine-tuning Complete ==="
echo ""
echo "LoRA adapters saved to: $PROJECT_DIR/lora_adapters"
echo ""
echo "Next steps:"
echo "  Run ./scripts/run_finetuned.sh to test the fine-tuned model"
echo "  Run ./scripts/run_ui.sh to launch the Gradio web UI"

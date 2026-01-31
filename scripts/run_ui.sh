#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Career Advisor Web UI ==="
echo ""

# Check for LoRA adapters
if [ ! -d "$PROJECT_DIR/lora_adapters" ]; then
    echo "ERROR: lora_adapters directory not found"
    echo "Please run ./scripts/finetune.sh first"
    exit 1
fi

# Activate virtual environment
if [ -d "$PROJECT_DIR/venv" ]; then
    source "$PROJECT_DIR/venv/bin/activate"
else
    echo "ERROR: Virtual environment not found. Run setup.sh first."
    exit 1
fi

echo "Starting Gradio web UI..."
echo "The UI will be available at http://localhost:7860"
echo ""

cd "$PROJECT_DIR"
python app.py

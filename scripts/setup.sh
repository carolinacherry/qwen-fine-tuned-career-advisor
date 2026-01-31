#!/bin/bash

set -e

echo "=== Career Advisor Setup ==="
echo ""

# Check for Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    echo "ERROR: This project requires Apple Silicon (M1/M2/M3/M4)"
    echo "Detected architecture: $(uname -m)"
    exit 1
fi
echo "✓ Apple Silicon detected"

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
echo "✓ Homebrew installed"

# Install Ollama
if ! command -v ollama &> /dev/null; then
    echo "Installing Ollama..."
    brew install ollama
fi
echo "✓ Ollama installed"

# Start Ollama service if not running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama service..."
    ollama serve &
    sleep 3
fi
echo "✓ Ollama service running"

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "Installing Python 3..."
    brew install python@3.11
fi
echo "✓ Python 3 installed"

# Create virtual environment if it doesn't exist
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [ ! -d "$PROJECT_DIR/venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$PROJECT_DIR/venv"
fi
echo "✓ Virtual environment ready"

# Activate venv and install dependencies
source "$PROJECT_DIR/venv/bin/activate"

echo "Installing Python dependencies..."
pip install --upgrade pip
pip install mlx mlx-lm transformers

echo "✓ Python dependencies installed"

# Pull base Qwen2.5-7B model
echo ""
echo "Pulling Qwen2.5-7B model (this may take a while)..."
ollama pull qwen2.5:7b

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Review training_data.jsonl"
echo "  2. Run ./scripts/run_baseline.sh to test base model"
echo "  3. Run ./scripts/finetune.sh to train"
echo "  4. Run ./scripts/run_finetuned.sh to test fine-tuned model"

# Training Log

## Training Run Details

**Date:** [Add date here]

**Hardware:**
- Mac Mini M4
- 16GB RAM
- macOS Sequoia

**Model:**
- Base: Qwen/Qwen2.5-3B-Instruct
- Fine-tuning: LoRA

**Parameters:**
```
--model Qwen/Qwen2.5-3B-Instruct
--data data/
--train
--iters 1000
--batch-size 1
--num-layers 8
--learning-rate 1e-5
```

**Dataset:**
- Training examples: 180
- Validation examples: 20
- Format: Chat template (messages array)

---

## Training Progress

[Add training output here]

```
Iteration 100/1000 - Loss: X.XX
Iteration 200/1000 - Loss: X.XX
...
```

---

## Training Time

- Total time: ~XX minutes
- Time per iteration: ~X.X seconds

---

## Memory Usage

- Peak RAM: ~12GB
- GPU memory: Using Metal (Apple Silicon unified memory)

---

## Observations

### What Worked
- [Add observations]

### What Could Be Improved
- [Add observations]

---

## Links

- Training recording: [Add link to Asciinema or video]
- Model weights: Not included in repo (too large)
- Adapter weights: `lora_adapters/` directory (after training)

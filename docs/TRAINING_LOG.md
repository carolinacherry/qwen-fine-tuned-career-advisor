# Training Log

## Training Run Details

**Date:** January 2025

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
--iters 2000
--batch-size 1
--num-layers 8
--learning-rate 1e-5
```

**Dataset:**
- Training examples: 367
- Format: Chat template (messages array)

---

## Training Progress

| Iteration | Validation Loss | Training Loss | Notes |
|-----------|-----------------|---------------|-------|
| 1 | 3.433 | - | Initial |
| 400 | 2.023 | 1.57 | **Best checkpoint** |
| 1000 | 2.116 | 1.29 | |
| 1800 | 2.678 | 0.41 | |
| 2000 | 2.738 | 0.49 | Final |

---

## Training Time

- Total time: ~38 minutes
- Iterations: 2000

---

## Memory Usage

- Peak RAM: 7.19 GB
- GPU memory: Using Metal (Apple Silicon unified memory)

---

## Observations

### Overfitting

The model begins overfitting after iteration 400:
- Validation loss reaches minimum (2.023) at iter 400
- Training loss continues dropping (1.57 → 0.49)
- Validation loss increases (2.023 → 2.738)

**Recommendation:** Use the iter 400 checkpoint for production. It generalizes better than the final iter 2000 checkpoint.

### Repetition Issues

Small models (3B parameters) may exhibit repetition in longer responses. This is a known limitation. Mitigation strategies:
- Use earlier checkpoints (iter 400)
- Set lower `max_tokens` during inference
- Use `repetition_penalty` parameter if available

### What Worked
- LoRA with 8 layers kept memory usage low
- Learning rate 1e-5 provided stable training
- Chat format training data worked well with Qwen2.5

### What Could Be Improved
- Early stopping based on validation loss
- Larger dataset to prevent overfitting
- Consider 7B model if more memory available

---

## Links

- Model weights: Not included in repo (too large)
- Adapter weights: `lora_adapters/` directory (after training)

# Contributing to Career Advisor

Thanks for your interest in contributing! This project aims to create an AI that gives direct, opinionated career advice based on real industry knowledge.

## Adding Training Examples

The most valuable contribution is adding high-quality training examples. Here's how:

### Format

Training data lives in `data/train.jsonl` and `data/valid.jsonl`. Each line is a JSON object:

```json
{"messages": [{"role": "user", "content": "Your question here?"}, {"role": "assistant", "content": "Direct, opinionated answer here."}]}
```

### Quality Guidelines

**DO:**
- Give direct recommendations ("Almost never", "Yes, but only if...", "No, here's why")
- Include specific numbers and statistics when relevant
- Reference real industry knowledge (levels.fyi, Blind, actual hiring practices)
- Explain the reasoning behind the advice
- Acknowledge exceptions briefly, but don't hedge the main recommendation
- Write in a conversational, peer-to-peer tone

**DON'T:**
- Start with "It depends" or "There are several factors to consider"
- Give generic advice that could apply to any situation
- Be wishy-washy or afraid to take a stance
- Write like a corporate HR document
- Include advice that's technically correct but useless in practice

### Example: Good vs Bad

**Bad (too generic):**
```json
{"messages": [{"role": "user", "content": "Should I negotiate my salary?"}, {"role": "assistant", "content": "Salary negotiation is a personal decision. Consider your market value, the company's budget, and your comfort level with negotiation. Research industry standards and practice your approach."}]}
```

**Good (direct and actionable):**
```json
{"messages": [{"role": "user", "content": "Should I negotiate my salary?"}, {"role": "assistant", "content": "Yes, always. Companies expect it — their first offer is rarely their best. Here's the playbook: 1) Never give a number first. 2) When they give a number, always counter. Even 'Is there flexibility?' works. 3) Negotiate total comp, not just base — RSUs and signing bonus often have more room. 4) Get competing offers if you can. That's your real leverage. The worst they can say is no, and they almost never rescind offers for polite negotiation."}]}
```

### Topics We Need More Examples For

- International job markets (UK, EU, India, etc.)
- Non-engineering tech roles (design, data science, DevOps)
- Career transitions (military to tech, academia to industry)
- Freelancing and contracting
- Technical leadership vs management trade-offs
- Startup equity evaluation in different funding stages
- Remote work negotiation and culture

## Submitting Changes

1. Fork the repository
2. Add your examples to `data/train.jsonl` (or `data/valid.jsonl` for validation)
3. Run a quick sanity check: `python -c "import json; [json.loads(l) for l in open('data/train.jsonl')]"`
4. Submit a pull request with a description of what topics your examples cover

## Code Contributions

For code changes:

1. Keep scripts simple and well-documented
2. Test on Apple Silicon (M1/M2/M3/M4) before submitting
3. Update README.md if you change any usage instructions

## Questions?

Open an issue if you're unsure about anything. We'd rather help you contribute than have you give up!

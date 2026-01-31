# Screenshots Guide

This document describes the screenshots in the `screenshots/` directory.

## Screenshot Descriptions

### ui_counteroffer.png
**Question:** "Should I accept a counteroffer from my current employer?"

Shows the model giving the direct "Almost never" response with specific reasoning about:
- 80% of counteroffer accepters leaving within 6 months
- Being marked as a flight risk
- Burning bridges with the offering company

### ui_promotion.png
**Question:** "I've been passed over for promotion twice. What should I do?"

Demonstrates the "Two times is a pattern, not bad luck" framing with advice to:
- Get brutally honest feedback
- Recognize when it's political
- Consider external opportunities

### ui_faang_vs_startup.png
**Question:** "Should I join a FAANG company or a startup?"

Shows the balanced but direct analysis including:
- FAANG benefits: brand name, stable TC, liquid stock
- Startup reality: "equity is worth $0 until it isn't"
- Decision framework based on financial situation

### ui_burnout.png
**Question:** "I'm burned out. Should I quit without another job lined up?"

Illustrates the empathetic but practical response:
- "Burnout doesn't heal while you're still burning"
- Runway calculation advice
- FMLA and benefits considerations

### ui_salary_negotiation.png
**Question:** "How do I negotiate a higher salary?"

Features the reframing: "Stop negotiating salary. Negotiate total compensation"
- The 5-step playbook
- RSU and signing bonus tactics
- Timing advice

---

## Taking Screenshots

To capture new screenshots:

1. Run the UI: `./scripts/run_ui.sh`
2. Open http://localhost:7860
3. Enter a question and wait for response
4. Use macOS screenshot: `Cmd + Shift + 4`
5. Crop to show the question and response clearly
6. Save to `screenshots/` directory

## Recommended Screenshot Dimensions

- Width: 1200px
- Height: Variable (capture full response)
- Format: PNG
- Background: Use the Soft theme (default)

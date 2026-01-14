---
name: gemini-agent
description: "Use Gemini CLI for tasks requiring massive context windows, Google Search grounding for current information, or a second opinion on architecture decisions. Triggers: need current best practices, research latest patterns, analyze large files, get alternative perspective, validate architecture, what does Google say about."
---

# Gemini CLI Tool

Use the Gemini CLI to leverage Google's Gemini model for specific tasks where it excels.

## When to Use Gemini

**✅ Excellent for:**
- **Research with Google Search grounding** - Current best practices, latest patterns, 2025 approaches
- **Large context analysis** - Analyzing large files/codebases that benefit from Gemini's context window
- **Architecture validation** - Second opinion on design decisions
- **Alternative perspectives** - Different training data may surface approaches you haven't considered

**❌ Skip Gemini for:**
- Simple, well-defined tasks you can do directly
- Iterative debugging (too slow for rapid iteration)
- Tasks requiring file modifications (use Codex or do directly)

## CLI Quick Reference

**Prerequisites:** Gemini CLI installed (`npm install -g @google/gemini-cli`) and authenticated (`gemini auth status`).

```bash
# Basic query (headless mode)
gemini "Your question here"

# With Google Search grounding (mention it in prompt)
gemini "Use google_web_search to find latest best practices for authentication in 2025"

# With project context
gemini "Analyze this for performance issues" --include-directories src,lib

# JSON output for parsing
gemini "List 3 alternatives" -o json

# Piped input (auto-headless)
cat large-file.ts | gemini "Analyze this code for issues"
```

## Prompt Patterns

**For research (always request web search explicitly):**
```bash
gemini "Use google_web_search to find the latest [X] patterns for 2025. Focus on: production examples, security considerations, performance benchmarks."
```

**For architecture review:**
```bash
gemini "I'm designing [X]. Let's think step by step: what are the trade-offs between [approach A] and [approach B]?"
```

**For large file analysis:**
```bash
cat src/large-module.ts | gemini "Analyze this module for: memory safety, async patterns, error handling. Suggest specific improvements."
```

## Evaluate Results Critically

Gemini provides suggestions, not authoritative answers. After getting results:

1. **Extract useful ideas** - What suggestions make sense for your context?
2. **Filter questionable advice** - What doesn't apply or seems off-base?
3. **Synthesize** - Combine good ideas with your own expertise
4. **Act** - Implement what makes sense, ignore what doesn't

Be honest when Gemini's response is generic or unhelpful - that's valuable signal too.

## Error Handling

**If Gemini CLI not found:**
```
Install: npm install -g @google/gemini-cli
Auth: gemini auth login
```

**If authentication fails:**
- Try `gemini auth login` (OAuth)
- Or `gcloud auth application-default login`
- Check API key if using that method: `echo $GOOGLE_API_KEY`

**If results are too generic:**
- Add more specific constraints to prompt
- Explicitly request `google_web_search` for current information
- Include code snippets or error messages
- Specify year (2025) for time-sensitive topics

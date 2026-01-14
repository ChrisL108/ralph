---
name: codex-agent
description: "Use Codex CLI (OpenAI) for bulk code generation, test generation, large-scale refactoring, and web-grounded research. Triggers: generate tests for, bulk refactor, code automation, research with web search, generate boilerplate, pattern enforcement, migrate code to."
---

# Codex CLI Tool

Use the Codex CLI to leverage OpenAI's Codex for specific tasks where it excels.

## When to Use Codex

**✅ Excellent for:**
- **Bulk code generation** - Tests, boilerplate, documentation across multiple files
- **Large-scale refactoring** - Pattern enforcement, migrations, code transformations
- **Research with web search** - Current best practices (requires `danger-full-access` sandbox)
- **Code analysis** - Security audits, architecture review, pattern detection

**❌ Skip Codex for:**
- Simple, single-file changes you can do directly
- Iterative debugging (too slow for rapid iteration)
- Tasks where you already have high confidence in the approach

## CLI Quick Reference

**Prerequisites:** Codex CLI installed (`brew install codex-cli` or see [docs](https://github.com/openai/codex-cli)) and authenticated (`codex login status`).

### Sandbox Modes (Critical for Safety)

| Mode | Use Case | Risk Level |
|------|----------|------------|
| `--sandbox read-only` | Analysis, review | Safest |
| `--sandbox workspace-write` | Code generation, refactoring | Medium |
| `--sandbox danger-full-access` | Web search (requires network) | ⚠️ High |

**Always use explicit sandbox flags. Never use `danger-full-access` in production environments.**

### Common Patterns

```bash
# Read-only analysis
codex exec --sandbox read-only "Analyze src/ for security issues" 2>/dev/null

# Generate tests (workspace-write)
codex exec --sandbox workspace-write "Generate unit tests for src/services/api.ts" 2>/dev/null

# Research with web search (requires danger-full-access for network)
codex exec --enable web_search_request --sandbox danger-full-access \
  "Search the web for authentication best practices 2025" 2>/dev/null

# Work in specific directory
codex exec --cd /path/to/project --sandbox read-only "Analyze architecture" 2>/dev/null

# Resume previous session
echo "Apply the refactoring we discussed" | codex exec --skip-git-repo-check resume --last 2>/dev/null
```

**Note:** Append `2>/dev/null` to suppress thinking tokens for cleaner output. Use `2>&1` when debugging.

## Web Search Requirements

Web search needs special configuration:

1. **Must use** `--enable web_search_request` (disabled by default)
2. **Must use** `--sandbox danger-full-access` (network access required)
3. Other sandbox modes block network requests silently

```bash
# Correct web search invocation
codex exec --enable web_search_request --sandbox danger-full-access \
  "Search the web for latest patterns for X in 2025" 2>/dev/null
```

**⚠️ Security:** `danger-full-access` allows full system access. Only use in trusted/isolated environments (VMs, containers, WSL).

## Prompt Patterns

**For test generation:**
```bash
codex exec --sandbox workspace-write \
  "Generate comprehensive unit tests for src/services/api.ts. Include: error handling, edge cases, async operations. Use modern testing patterns with appropriate mocking." 2>/dev/null
```

**For bulk refactoring:**
```bash
codex exec --sandbox workspace-write \
  "Refactor src/legacy/ to use modern async/await patterns. Maintain existing functionality, improve error handling, add TypeScript types." 2>/dev/null
```

**For research:**
```bash
codex exec --enable web_search_request --sandbox danger-full-access \
  "Search the web for 'database partitioning best practices 2025'. Focus on: performance, scalability, real-world examples." 2>/dev/null
```

## Evaluate Results Critically

Codex provides suggestions, not authoritative answers. After getting results:

1. **Review generated code** - Is it correct, clean, and maintainable?
2. **Check for issues** - Missing edge cases? Wrong patterns for your codebase?
3. **Filter bad suggestions** - Generic advice that doesn't fit your context
4. **Test before committing** - Run tests, typecheck, lint

Be honest when Codex output needs significant modification - that's normal.

## Error Handling

**If Codex CLI not found:**
```
Install: brew install codex-cli
Auth: codex login
```

**If authentication fails:**
- Run `codex login` to authenticate
- Verify ChatGPT Plus subscription (or API key)
- Check status: `codex login status`

**If web search doesn't work:**
- Verify `--enable web_search_request` flag is present
- Verify `--sandbox danger-full-access` is used
- Check feature: `codex features list | grep web_search_request`
- Codex says "no web search capability" without correct flags

**If results are too generic:**
- Add more specific constraints (file paths, function names, patterns)
- Include code snippets in prompt
- Use web search for current best practices
- Specify technologies and versions explicitly

## Known Limitations

- ⚠️ Approval controls may auto-approve despite configuration
- ⚠️ ChatGPT Plus has rate limits
- ⚠️ Always review generated code before accepting

**Mitigation:** Always use sandbox flags, review all changes, work on feature branches.

# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs Claude Code repeatedly until all PRD items are complete. Each iteration is a fresh Claude instance with clean context.

## Commands

```bash
# Run the flowchart dev server
cd flowchart && npm run dev

# Build the flowchart
cd flowchart && npm run build

# Run Ralph (from your project that has prd.json)
./ralph.sh [max_iterations]
```

## Key Files

- `ralph.sh` - The bash loop that spawns fresh Claude instances
- `prompt.md` - Instructions given to each Claude instance
- `prd.json.example` - Example PRD format
- `flowchart/` - Interactive React Flow diagram explaining how Ralph works

## Available Skills

- `skills/prd/` - Generate PRDs from feature descriptions
- `skills/ralph/` - Convert markdown PRDs to prd.json format
- `skills/gemini-agent/` - Use Gemini CLI for research and large context analysis
- `skills/codex-agent/` - Use Codex CLI for bulk code generation and refactoring

## Recommended Plugins

- `sawyerhood/dev-browser` - Browser automation for UI verification (install via `/plugin install dev-browser@sawyerhood/dev-browser`)

## Flowchart

The `flowchart/` directory contains an interactive visualization built with React Flow. It's designed for presentations - click through to reveal each step with animations.

To run locally:
```bash
cd flowchart
npm install
npm run dev
```

## Patterns

- Each iteration spawns a fresh Claude instance with clean context
- Memory persists via git history, `progress.txt`, and `prd.json`
- Stories should be small enough to complete in one context window
- Always update AGENTS.md with discovered patterns for future iterations
- Gemini/Codex skills are available when Claude needs additional capabilities

#!/bin/bash
# Monitor Ralph progress in real-time
# Usage: ./scripts/monitor.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRD_FILE="$SCRIPT_DIR/ralph/prd.json"
PROGRESS_FILE="$SCRIPT_DIR/ralph/progress.txt"

while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║           RALPH MONITOR - $(date '+%H:%M:%S')                        ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  
  if [ -f "$PRD_FILE" ]; then
    echo ""
    echo "📋 USER STORIES STATUS:"
    echo "────────────────────────────────────────────────────────────────"
    cat "$PRD_FILE" | jq -r '.userStories[] | "\(if .passes then "✅" else "⬜" end) \(.id): \(.title)"' 2>/dev/null || echo "  (waiting for prd.json...)"
    
    TOTAL=$(cat "$PRD_FILE" | jq '.userStories | length' 2>/dev/null || echo 0)
    DONE=$(cat "$PRD_FILE" | jq '[.userStories[] | select(.passes == true)] | length' 2>/dev/null || echo 0)
    echo ""
    echo "  Progress: $DONE / $TOTAL stories complete"
  else
    echo ""
    echo "📋 Waiting for prd.json to be created..."
  fi
  
  echo ""
  echo "📝 RECENT PROGRESS:"
  echo "────────────────────────────────────────────────────────────────"
  if [ -f "$PROGRESS_FILE" ]; then
    tail -15 "$PROGRESS_FILE" | head -12
  else
    echo "  (no progress.txt yet)"
  fi
  
  echo ""
  echo "🔀 RECENT COMMITS:"
  echo "────────────────────────────────────────────────────────────────"
  git --no-pager log --oneline -5 2>/dev/null || echo "  (no commits yet)"
  
  echo ""
  echo "────────────────────────────────────────────────────────────────"
  echo "Press Ctrl+C to exit | Refreshing every 10 seconds..."
  
  sleep 10
done

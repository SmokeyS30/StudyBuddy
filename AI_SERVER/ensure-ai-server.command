#!/bin/zsh
set -e
unsetopt bg_nice 2>/dev/null || true

cd "$(dirname "$0")"

SERVER_HOST="${STUDYBUDDY_AI_HOST:-127.0.0.1}"
SERVER_PORT="${STUDYBUDDY_AI_PORT:-8787}"
HEALTH_URL="http://${SERVER_HOST}:${SERVER_PORT}/health"
LOG_FILE="${TMPDIR:-/tmp}/studybuddy-ai-server.log"
PID_FILE="${TMPDIR:-/tmp}/studybuddy-ai-server.pid"

if command -v curl >/dev/null 2>&1 && curl -fsS --max-time 1 "$HEALTH_URL" >/dev/null 2>&1; then
  echo "StudyBuddy AI Server already running at $HEALTH_URL"
  exit 0
fi

if command -v node >/dev/null 2>&1; then
  NODE_BIN="$(command -v node)"
elif [ -x /opt/homebrew/bin/node ]; then
  NODE_BIN="/opt/homebrew/bin/node"
elif [ -x /usr/local/bin/node ]; then
  NODE_BIN="/usr/local/bin/node"
elif [ -x /Users/smokeys30/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node ]; then
  NODE_BIN="/Users/smokeys30/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"
else
  echo "Node.js was not found. Install Node 18 or newer."
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
  chmod 600 .env
  echo "Created .env from .env.example. Add OPENAI_API_KEY for live OpenAI tutoring."
fi

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" >/dev/null 2>&1; then
  echo "Found StudyBuddy AI Server PID $(cat "$PID_FILE"), waiting for health..."
  for _ in 1 2 3; do
    if command -v curl >/dev/null 2>&1 && curl -fsS --max-time 1 "$HEALTH_URL" >/dev/null 2>&1; then
      echo "StudyBuddy AI Server is online."
      exit 0
    fi
    sleep 1
  done
fi

echo "Starting StudyBuddy AI Server at $HEALTH_URL"
env HOST="$SERVER_HOST" PORT="$SERVER_PORT" "$NODE_BIN" server.js >> "$LOG_FILE" 2>&1 < /dev/null &!
SERVER_PID="$!"
echo "$SERVER_PID" > "$PID_FILE"
sleep 1

if command -v curl >/dev/null 2>&1 && curl -fsS --max-time 2 "$HEALTH_URL" >/dev/null 2>&1; then
  echo "StudyBuddy AI Server is online."
else
  echo "StudyBuddy AI Server was started. Check $LOG_FILE if it does not appear online."
fi

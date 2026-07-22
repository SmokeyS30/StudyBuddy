#!/bin/zsh
set -e

cd "$(dirname "$0")"

SERVER_HOST="${STUDYBUDDY_AI_HOST:-127.0.0.1}"
SERVER_PORT="${STUDYBUDDY_AI_PORT:-8787}"
HEALTH_URL="http://${SERVER_HOST}:${SERVER_PORT}/health"

if command -v node >/dev/null 2>&1; then
  NODE_BIN="$(command -v node)"
elif [ -x /opt/homebrew/bin/node ]; then
  NODE_BIN="/opt/homebrew/bin/node"
elif [ -x /usr/local/bin/node ]; then
  NODE_BIN="/usr/local/bin/node"
elif [ -x /Users/smokeys30/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node ]; then
  NODE_BIN="/Users/smokeys30/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"
else
  echo "Node.js was not found. Install Node 18 or newer, then run this file again."
  read "?Press Return to close."
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
  chmod 600 .env
  echo "Created .env from .env.example."
fi

CURRENT_KEY="$(awk -F= '/^OPENAI_API_KEY=/{print substr($0, index($0, "=") + 1)}' .env | tail -1)"

if [ -n "$CURRENT_KEY" ] && [[ "$CURRENT_KEY" != sk-* ]]; then
  echo "AI_SERVER/.env contains a value that is not an OpenAI API key. OpenAI keys start with sk-."
  echo "That value will not be used for AI tutoring."
  CURRENT_KEY=""
fi

if [ -z "$CURRENT_KEY" ] && [ -t 0 ]; then
  echo "Paste your OpenAI API key once. Input is hidden."
  echo "Press Return without typing anything to start with local fallback coaching."
  stty -echo
  read -r "?OpenAI API key: " OPENAI_KEY
  stty echo
  echo

  if [ -n "$OPENAI_KEY" ]; then
    if [[ "$OPENAI_KEY" != sk-* ]]; then
      echo "That is not an OpenAI API key. OpenAI API keys start with sk-. It was not saved."
    else
      awk -v key="$OPENAI_KEY" '
        BEGIN { wrote = 0 }
        /^OPENAI_API_KEY=/ {
          print "OPENAI_API_KEY=" key
          wrote = 1
          next
        }
        { print }
        END {
          if (!wrote) print "OPENAI_API_KEY=" key
        }
      ' .env > .env.tmp
      mv .env.tmp .env
      chmod 600 .env
      CURRENT_KEY="$OPENAI_KEY"
    fi
  fi
fi

if [ -n "$CURRENT_KEY" ]; then
  echo "OpenAI API key is configured locally in AI_SERVER/.env."
else
  echo "No OpenAI API key is configured. The server will use local fallback coaching."
fi

if command -v curl >/dev/null 2>&1 && curl -fsS --max-time 1 "$HEALTH_URL" >/dev/null 2>&1; then
  echo "StudyBuddy AI Server is already running at $HEALTH_URL"
  exit 0
fi

echo "Starting StudyBuddy AI Server..."
echo "Open StudyBuddy Settings and use: http://${SERVER_HOST}:${SERVER_PORT}"
exec env HOST="$SERVER_HOST" PORT="$SERVER_PORT" "$NODE_BIN" server.js

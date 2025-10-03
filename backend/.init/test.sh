#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/bookstore-online-platform-146925-146936/backend"
cd "$WORKSPACE"
export NODE_ENV=test
# Prefer project-local jest
if [ -x node_modules/.bin/jest ]; then JEST_BIN=node_modules/.bin/jest; else
  echo "Local jest missing; restoring dependencies" >&2
  npm ci --no-audit --no-fund --silent
  [ -x node_modules/.bin/jest ] || { echo "ERROR: jest not available after install" >&2; exit 4; }
  JEST_BIN=node_modules/.bin/jest
fi
# Run tests and capture output
$JEST_BIN --runInBand --silent 2>&1 | tee /tmp/test_run.log || { echo 'Tests failed - see /tmp/test_run.log' >&2; exit 5; }

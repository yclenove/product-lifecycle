#!/usr/bin/env bash
# 本地预览 docs-site（需 Python 3）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${1:-8765}"
cd "$ROOT"
echo "文档站: http://127.0.0.1:${PORT}/docs-site/index.html"
exec python3 -m http.server "$PORT"

#!/usr/bin/env bash
# bump-version.sh — 自动递增版本号
#
# 用法：
#   bash scripts/bump-version.sh patch   # 2.1.0 → 2.1.1
#   bash scripts/bump-version.sh minor   # 2.1.0 → 2.2.0
#   bash scripts/bump-version.sh major   # 2.1.0 → 3.0.0
#
# 说明：
#   - 从 CHANGELOG.md 读取当前版本号
#   - 支持 major/minor/patch 三种递增方式
#   - 输出格式：旧版本 → 新版本

set -euo pipefail

BUMP_TYPE="${1:-patch}"
ROOT="$(dirname "$(dirname "$0")")"

# 从 CHANGELOG 获取当前版本
CURRENT=$(grep -m1 '^\## \[' "$ROOT/CHANGELOG.md" | head -2 | tail -1 | sed 's/## \[\(.*\)\].*/\1/' | grep -o '[0-9]*\.[0-9]*\.[0-9]*' || echo "0.0.0")

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$BUMP_TYPE" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
  *) echo "用法: $0 [major|minor|patch]"; exit 1 ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "$CURRENT → $NEW_VERSION"

#!/usr/bin/env bash
# gen-changelog.sh — 从 Git log 自动生成 CHANGELOG 条目
#
# 用法：bash scripts/gen-changelog.sh [版本号]
# 示例：bash scripts/gen-changelog.sh 2.2.0
#
# 说明：
#   - 自动从最近一周的 Git 提交记录生成 CHANGELOG 条目
#   - 按 Added/Changed/Fixed 三个类别分类
#   - 版本号可选，默认使用当前日期

set -euo pipefail

VERSION="${1:-$(date +%Y%m%d)}"
ROOT="$(dirname "$(dirname "$0")")"

echo "## [$VERSION] - $(date +%Y-%m-%d)"
echo ""
echo "### Added"
git log --oneline --since="1 week ago" --grep="feat\|add\|new" --format="- %s" 2>/dev/null || echo "- (无)"
echo ""
echo "### Changed"
git log --oneline --since="1 week ago" --grep="refactor\|update\|improve" --format="- %s" 2>/dev/null || echo "- (无)"
echo ""
echo "### Fixed"
git log --oneline --since="1 week ago" --grep="fix\|bug\|repair" --format="- %s" 2>/dev/null || echo "- (无)"

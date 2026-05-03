#!/bin/bash
# 项目自动检测脚本 - 识别技术栈、已有文档、测试框架
# 用法: bash detect.sh [项目路径]

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || exit 1

echo "=== 项目检测报告 ==="
echo "路径: $(pwd)"
echo "时间: $(date '+%Y-%m-%d %H:%M')"
echo

# 1. 语言和框架检测
echo "## 技术栈"
[ -f "go.mod" ] && echo "- Go $(head -1 go.mod | awk '{print $2}') | 测试: go test | Lint: go vet"
[ -f "package.json" ] && echo "- Node.js | 测试: npm test | Lint: npm run lint"
[ -f "requirements.txt" ] && echo "- Python | 测试: pytest | Lint: flake8"
[ -f "pyproject.toml" ] && echo "- Python (pyproject) | 测试: pytest | Lint: ruff"
[ -f "Cargo.toml" ] && echo "- Rust | 测试: cargo test | Lint: cargo clippy"
[ -f "pom.xml" ] && echo "- Java (Maven) | 测试: mvn test | Lint: mvn checkstyle:check"
[ -f "build.gradle" ] && echo "- Java (Gradle) | 测试: gradle test | Lint: gradle check"
[ -f "Gemfile" ] && echo "- Ruby | 测试: bundle exec rspec | Lint: rubocop"
[ -f "Dockerfile" ] && echo "- Docker: 有 Dockerfile"
[ -f "docker-compose.yml" ] && echo "- Docker Compose: 有 docker-compose.yml"
[ -f "docker-compose.yaml" ] && echo "- Docker Compose: 有 docker-compose.yaml"
echo

# 2. 已有文档检测
echo "## 已有文档"
[ -f "README.md" ] && echo "- README.md ($(wc -l < README.md) 行)" || echo "- README.md: 无"
[ -f "CHANGELOG.md" ] && echo "- CHANGELOG.md ($(wc -l < CHANGELOG.md) 行)" || echo "- CHANGELOG.md: 无"
[ -f "CLAUDE.md" ] && echo "- CLAUDE.md ($(wc -l < CLAUDE.md) 行)" || echo "- CLAUDE.md: 无"
[ -d "docs" ] && echo "- docs/ 目录: $(ls docs/*.md 2>/dev/null | wc -l) 个 md 文件" || echo "- docs/ 目录: 无"
[ -d ".claude" ] && echo "- .claude/ 目录: 已配置" || echo "- .claude/ 目录: 无"
echo

# 3. 测试覆盖检测
echo "## 测试覆盖"
[ -d "tests" ] && echo "- tests/ 目录: $(find tests -name '*.test.*' -o -name '*_test.*' -o -name 'test_*' 2>/dev/null | wc -l) 个测试文件"
[ -d "test" ] && echo "- test/ 目录: $(find test -name '*.test.*' -o -name '*_test.*' -o -name 'test_*' 2>/dev/null | wc -l) 个测试文件"
[ -d "__tests__" ] && echo "- __tests__/ 目录: $(find __tests__ -name '*.test.*' 2>/dev/null | wc -l) 个测试文件"
[ -d "spec" ] && echo "- spec/ 目录: $(find spec -name '*_spec.*' 2>/dev/null | wc -l) 个测试文件"
echo

# 4. Git 状态
echo "## Git 状态"
[ -d ".git" ] && echo "- 分支: $(git branch --show-current 2>/dev/null)" || echo "- 非 Git 仓库"
[ -d ".git" ] && echo "- 提交数: $(git rev-list --count HEAD 2>/dev/null)"
[ -d ".git" ] && echo "- 最近提交: $(git log -1 --format='%s' 2>/dev/null)"
echo

# 5. 文件统计
echo "## 文件统计"
echo "- 总文件数: $(find . -type f -not -path './.git/*' -not -path './node_modules/*' 2>/dev/null | wc -l)"
echo "- 代码行数: $(find . -type f \( -name '*.go' -o -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rs' -o -name '*.java' \) -not -path './.git/*' -not -path './node_modules/*' 2>/dev/null -exec cat {} + 2>/dev/null | wc -l)"

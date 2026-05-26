# product-lifecycle 静态文档站

面向**零基础读者**的 HTML 文档包：双击或本地 HTTP 即可阅读。

## 打开方式

```bash
# 方式 1：本地服务（推荐，侧栏路径正确）
bash scripts/serve-docs.sh
# 浏览器打开 http://127.0.0.1:8765/docs-site/index.html

# 方式 2：直接打开 index.html（部分浏览器 file:// 下搜索/路径可能受限）
```

## 维护

- 手写页：改 `docs-site/**/*.html`
- 角色页：改 `agents/*.md` 后运行 `bash scripts/generate-docs-site.sh`
- 导航：改 `assets/nav-data.js`

## 与 `docs/` 的关系

| 目录 | 受众 | 形态 |
|------|------|------|
| `docs/` | 维护者、AI、贡献者 | Markdown，偏精炼 |
| `docs-site/` | 新人、团队培训 | HTML，偏教程与名词解释 |

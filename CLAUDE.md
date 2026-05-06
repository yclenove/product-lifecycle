# Claude Code（本仓库）

调用 **Read** 读取非 PDF（含 `.md`、代码、配置）时：**不要传 `pages` 参数**——从 JSON 里删掉整个键；禁止 `"pages": ""`。否则客户端校验会报错。

# DSH 插件备份 · desktop profile

把本机 **DeepSeek Harness** 的 `desktop` profile 上安装的全部插件做成一份可还原的快照。
本仓库**不含任何密钥、token 或账号凭据**，可以公开。

- 生成时间：2026/10/20 14:45:33（Asia/Shanghai）
- 主机：XTJY-20250303XH · Windows_NT 10.0.19045 x64
- DSH 版本：0.2.1-rc.2 · Node v24.21.0
- 已安装依赖（插件包）：**26** 个，合计约 **413.1 MB**
- 启用为 bundle 的：**28** 个 —— 你装的 26 个全部启用，另有 2 个是 DSH 自带
- 插件代码本身不落库，靠 `profile/pnpm-lock.yaml` 里固定的版本号与 integrity 哈希精确还原

## 插件清单

| # | 包名 | 版本 | 来源 | 已启用 | 前端 | 名称 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `dsh-plugin` | 2.0.4 | npm | ✔ | UI | — |
| 2 | `dshmarket` | 1.66.42 | npm | ✔ | UI | — |
| 3 | `billion-context` | 0.1.202 | npm | ✔ | UI | — |
| 4 | `dsh-better-sidebar` | 0.28.0 | npm | ✔ | UI | — |
| 5 | `dsh-whale-widget` | 0.4.2 | npm | ✔ |  | — |
| 6 | `@liustack/modlens` | 3.27.1 | npm | ✔ | UI | — |
| 7 | `@vectorize-io/hindsight-coding-agents` | 0.8.2 | npm | ✔ |  | — |
| 8 | `@michengai/dsh-skills-manager` | 1.2.8 | npm | ✔ | UI | — |
| 9 | `dsh-wechat` | 0.12.0 | npm | ✔ | UI | — |
| 10 | `@dsh-external/dsh-blender-plugin` | 2.5.0 | GitHub | ✔ | UI | — |
| 11 | `@michengai/dsh-agency-agents` | 1.2.8 | npm | ✔ | UI | — |
| 12 | `dsh-context` | 0.73.3 | npm | ✔ | UI | — |
| 13 | `dsh-continual-evolve` | 0.19.2 | npm | ✔ | UI | — |
| 14 | `dsh-ops` | 0.3.2 | npm | ✔ |  | — |
| 15 | `@linxin666/dsh-client-ui-skill-explorer` | 0.4.8 | npm | ✔ | UI | — |
| 16 | `@michengai/dsh-archive-manager` | 1.1.6 | npm | ✔ | UI | — |
| 17 | `dsh-mnemon` | 0.5.33 | npm | ✔ | UI | — |
| 18 | `dsh-free-search` | 0.9.7 | npm | ✔ | UI | — |
| 19 | `dsh-univer-office` | 0.3.7 | npm | ✔ | UI | — |
| 20 | `@openviking/dsh-memory-plugin` | 0.5.26 | npm | ✔ |  | — |
| 21 | `@wxg-prc-cpg/browser-skill-dsh-plugin` | 0.3.3 | npm | ✔ | UI | — |
| 22 | `dsh-image-gen` | 0.9.2 | npm | ✔ | UI | — |
| 23 | `@furongjun1999/dsh-memory` | 0.9.7 | npm | ✔ |  | — |
| 24 | `dsh-github-sync` | 1.0.0 | GitHub | ✔ | UI | GitHub Sync |
| 25 | `@goodandready/dsh-model-sync` | 0.5.15 | npm | ✔ | UI | — |
| 26 | `@dpskk2/dsh-chatsync` | 0.20.0 | npm | ✔ | UI | — |

“已启用”= 出现在 profile 的 `dsh.profile.bundles` 里，即真正加载运行。
“前端”= 包内声明了 `dsh.client`，会在 Web UI 里注册面板/槽位。

DSH 自带的 bundle（不需要单独安装）：`@deepseek-ai/dsh-base`、`@deepseek-ai/dsh-web-app`

## 目录结构

```
manifest.json              机器可读清单（每个插件的版本、来源、启用状态、体积、仓库地址）
restore.ps1                一键还原脚本
profile/package.json       profile 依赖表 + bundle 加载顺序（原样）
profile/pnpm-lock.yaml     精确版本 + integrity 哈希（还原的决定性文件）
profile/pnpm-workspace.yaml  pnpm 工作区配置
profile/cordis.patch.yml   你的配置层（主题、模型、各插件 config）
profile/cordis.yml         profile 根（空数组，由各 layer 组合）
```

## 还原方法

新机器上先装好 DSH，然后在**已登录、且带有 pnpm 的 DSH 环境**里执行：

```powershell
.\restore.ps1                    # 默认还原到 $HOME\.dsh 的 desktop profile
.\restore.ps1 -Profile myprofile  # 还原到别的 profile 名
```

脚本做两件事：逐个 `dsh plugin --profile <名> add <包@版本>` 安装插件，再把 `profile/cordis.patch.yml` 覆盖上去。
装完重启 DSH 生效。

> 手工还原也可以：把 `profile/package.json`、`pnpm-lock.yaml`、`pnpm-workspace.yaml` 放进
> `%USERPROFILE%\.dsh\profiles\<名>\`，在该目录跑一次 `pnpm install`，最后放回 `cordis.patch.yml`。

## 注意

- 两个插件是从 GitHub 提交装的，不是 npm 版本：见清单里来源为 GitHub 的条目，还原时需能访问 GitHub。
- `restore.ps1` 走的是 `dsh plugin add`，如果某个包因为网络/权限没装上，脚本会提示你改走锁文件：
  把 `profile/` 里的 `package.json`、`pnpm-lock.yaml`、`pnpm-workspace.yaml` 拷进 profile 目录跑 `pnpm install`，
  这条路连 integrity 哈希都固定了，是最精确的还原方式。
- `cordis.patch.yml` 里的图片生成插件只存了 baseURL 与模型名，**没有**存 API Key；Key 需要你重新填。
- 配置层有 1 行引用了本机没装的包（`pet -> @linxin666/dsh-pet`），那一行本来就是失效状态，还原后也一样。

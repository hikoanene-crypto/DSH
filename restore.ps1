<#
.SYNOPSIS
  还原本机 DSH profile 的插件集合（由 dsh-plugins-backup 生成）。

.PARAMETER Profile
  目标 profile 名，默认 desktop。

.PARAMETER DshHome
  DSH 主目录，默认 $HOME\.dsh。

.NOTES
  需要 dsh CLI 在 PATH 中（或由 -DshCmd 指定）。装完重启 DSH 生效。
#>
[CmdletBinding()]
param(
  [string]$Profile = 'desktop',
  [string]$DshHome = (Join-Path $HOME '.dsh'),
  [string]$DshCmd = 'dsh'
)

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$profileDir = Join-Path (Join-Path $DshHome 'profiles') $Profile

if (-not (Get-Command $DshCmd -ErrorAction SilentlyContinue)) {
  throw "找不到 dsh 命令。请把 DSH 的 cli/bin 加进 PATH，或用 -DshCmd 指定 dsh.cmd 的完整路径。"
}

New-Item -ItemType Directory -Force -Path $profileDir | Out-Null

$script:failed = @()
function Add-Plugin([string]$spec) {
  Write-Host "==> dsh plugin add $spec" -ForegroundColor Cyan
  & $DshCmd plugin --profile $Profile add $spec
  if ($LASTEXITCODE -ne 0) { $script:failed += $spec }
}

Add-Plugin 'dsh-plugin@^2.0.4'  # package.json 里的 spec: ^2.0.4
Add-Plugin 'dshmarket@^1.66.42'  # package.json 里的 spec: ^1.66.42
Add-Plugin 'billion-context@0.1.202'  # package.json 里的 spec: 0.1.202
Add-Plugin 'dsh-better-sidebar@0.28.0'  # package.json 里的 spec: 0.28.0
Add-Plugin 'dsh-whale-widget@0.4.2'  # package.json 里的 spec: 0.4.2
Add-Plugin '@liustack/modlens@3.27.1'  # package.json 里的 spec: 3.27.1
Add-Plugin '@vectorize-io/hindsight-coding-agents@0.8.2'  # package.json 里的 spec: 0.8.2
Add-Plugin '@michengai/dsh-skills-manager@1.2.8'  # package.json 里的 spec: 1.2.8
Add-Plugin 'dsh-wechat@0.12.0'  # package.json 里的 spec: 0.12.0
Add-Plugin 'github:sixtysevenlf/dsh-blender-plugin#f044a019bbb97513443b24cc5ebcad111a002628'  # GitHub 提交装的，包名 @dsh-external/dsh-blender-plugin
Add-Plugin '@michengai/dsh-agency-agents@1.2.8'  # package.json 里的 spec: 1.2.8
Add-Plugin 'dsh-context@0.73.3'  # package.json 里的 spec: 0.73.3
Add-Plugin 'dsh-continual-evolve@0.19.2'  # package.json 里的 spec: 0.19.2
Add-Plugin 'dsh-ops@0.3.2'  # package.json 里的 spec: 0.3.2
Add-Plugin '@linxin666/dsh-client-ui-skill-explorer@0.4.8'  # package.json 里的 spec: 0.4.8
Add-Plugin '@michengai/dsh-archive-manager@1.1.6'  # package.json 里的 spec: 1.1.6
Add-Plugin 'dsh-mnemon@0.5.33'  # package.json 里的 spec: 0.5.33
Add-Plugin 'dsh-free-search@0.9.7'  # package.json 里的 spec: 0.9.7
Add-Plugin 'dsh-univer-office@0.3.7'  # package.json 里的 spec: 0.3.7
Add-Plugin '@openviking/dsh-memory-plugin@0.5.26'  # package.json 里的 spec: 0.5.26
Add-Plugin '@wxg-prc-cpg/browser-skill-dsh-plugin@0.3.3'  # package.json 里的 spec: 0.3.3
Add-Plugin 'dsh-image-gen@0.9.2'  # package.json 里的 spec: 0.9.2
Add-Plugin '@furongjun1999/dsh-memory@0.9.7'  # package.json 里的 spec: 0.9.7
Add-Plugin 'github:wzw4429-crypto/dsh-github-sync#9112dc975a83a5cc101555eb3c93c0825ff30dfb'  # GitHub 提交装的，包名 dsh-github-sync
Add-Plugin '@goodandready/dsh-model-sync@0.5.15'  # package.json 里的 spec: 0.5.15
Add-Plugin '@dpskk2/dsh-chatsync@0.20.0'  # package.json 里的 spec: 0.20.0

# 配置层最后覆盖：主题 / 模型 / 各插件的 config
$patchSrc = Join-Path $here 'profile\cordis.patch.yml'
if (Test-Path $patchSrc) {
  Copy-Item $patchSrc (Join-Path $profileDir 'cordis.patch.yml') -Force
  Write-Host "==> 已还原 cordis.patch.yml" -ForegroundColor Cyan
}

if ($script:failed.Count -gt 0) {
  Write-Host ""
  Write-Warning ("以下插件没装上：" + ($script:failed -join ', '))
  Write-Host ""
  Write-Host "改用锁文件精确还原（能把上面失败的也一并装上）：" -ForegroundColor Yellow
  Write-Host "  1) 把 profile\package.json、profile\pnpm-lock.yaml、profile\pnpm-workspace.yaml 拷进 $profileDir"
  Write-Host "  2) cd $profileDir 后跑 pnpm install"
  exit 1
}

Write-Host ""
Write-Host "全部插件已安装。重启 DSH 后用 dsh plugin --profile $Profile list 核对。" -ForegroundColor Green

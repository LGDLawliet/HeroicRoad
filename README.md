# HeroicRoad

Dota 2 自定义游戏工程，Addon 名称为 `herodefense`，默认地图为 `camp_defense`。

此版本使用 Lua 本地存档适配器运行原有业务接口。登录、结算、符石等操作在局内处理，无需原作者的在线业务服务器。

## 目录

| 路径 | 内容 |
| --- | --- |
| `game/herodefense/scripts/vscripts/` | Lua 游戏逻辑，服务端入口为 `addon_game_mode.lua` |
| `game/herodefense/scripts/npc/` | 单位、技能、物品等 KV 配置 |
| `game/herodefense/` | 可运行的 Addon 文件与编译后的 Source 2 资源 |
| `content/herodefense/` | 地图、模型、材质、特效及 Panorama 源资源 |
| `content/herodefense/panorama/` | UI 的 XML、JavaScript、CSS/LESS 源文件 |
| `工具/tool_scripts/` | 历史辅助工具与文档 |

## 获取项目

需要 Git、Git LFS，以及安装了 Dota 2 Workshop Tools 的 Dota 2。完整项目包含较多美术资源，下载时请预留足够的磁盘空间。

```powershell
git lfs install
git clone https://github.com/LGDLawliet/HeroicRoad.git
cd HeroicRoad
git lfs pull
```

贴图、模型、音频等资源由 Git LFS 管理。请使用上述 Git 方式获取完整资源，避免将 LFS 指针文件当作实际素材。

## 准备本地存档

真实作者存档不纳入版本控制。首次使用时，在仓库根目录执行：

```powershell
$archiveDir = "game/herodefense/scripts/vscripts/internal"
if (-not (Test-Path "$archiveDir/local_archive_data.lua")) {
    Copy-Item "$archiveDir/local_archive_data.example.lua" "$archiveDir/local_archive_data.lua"
}
```

公开示例已替换玩家身份、移除排行榜和待领奖励记录，并使用固定示例日期；保留了技能、符石、外观、特权和自定义玩法进度。它是用于离线体验的预置模板，不代表新玩家的初始平衡配置。

`local_archive_data.lua` 与 `resource/作者存档.json` 已被 Git 忽略。已有个人存档时，上面的命令会保留原件。

## 在 Workshop Tools 中使用

1. 将仓库的 `content/herodefense` 放到 Dota 2 安装目录下的 `content/dota_addons/herodefense`。
2. 将仓库的 `game/herodefense` 放到 Dota 2 安装目录下的 `game/dota_addons/herodefense`，包含上一步准备的本地存档文件。如果安装目录已有同名工程，先备份。
3. 启动 Dota 2 Workshop Tools，选择 `herodefense`。默认地图是 `camp_defense`，地图源文件位于 `content/herodefense/maps/camp_defense.vmap`。
4. 修改地图或资源后，使用 Workshop Tools 编译并运行地图。

仓库以普通目录保存工程内容；本机开发可以自行使用目录链接连接到 Dota 2 的 Addon 目录，不需要沿用作者机器上的绝对路径。

## 本地业务接口

`GAME_server_address = "http://local-archive/"` 只是路由前缀，无需配置该域名或启动 HTTP 服务：

```text
游戏逻辑 → LocalArchive.CreateRequest → 本地存档逻辑 → 原业务回调
```

- `internal/local_archive.lua` 负责请求兼容与分发。
- `internal/local_archive_store.lua` 负责本局内的数据与业务操作。
- 每位玩家从模板获取独立副本，Steam 身份在运行时绑定。
- 结算、购买等更改仅保存在本局内存中，不会写回存档文件；新一局重新加载模板。
- 本地模式不支持的在线操作会返回失败；没有原服务器回退。

## 开发说明

Lua 逻辑由 Dota 2 加载。Panorama 源码入口为 `content/herodefense/panorama/layout/custom_game/custom_ui_manifest.xml`，资源编译由 Workshop Tools 完成。

根目录 `package.json` 和锁文件保留了历史 Node.js 工具依赖。目前唯一的 `wearables` 脚本指向缺失的 `scripts/wearables.js`，也没有可用的统一 `npm run build` 配置；运行 Addon 不以该命令为前提。

本机编辑器配置、凭证、个人存档和工具缓存已被忽略。不要强制提交这些文件。

## 许可证

项目原创代码与文档使用 [MIT License](LICENSE)。Dota 2 / Valve 内容及其他第三方代码和素材保留各自权利与授权条件，详见 [第三方说明](THIRD_PARTY_NOTICES.md)。

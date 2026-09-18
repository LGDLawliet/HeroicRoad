# HeroicRoad

简体中文 | [English](README.en.md)

Dota 2 自定义游戏工程，Addon 名称为 `herodefense`，默认地图为 `camp_defense`。

此版本使用 Lua 本地存档适配器运行原有业务接口。登录、结算、符石等操作在局内处理，无需原作者的在线业务服务器。

## 项目版本

- **版本名称：英雄之路:乱纪元 V 2.1G**
- **英文名称：Heroic Road:Chaotic Era.2.1G**
- **开发始于：2021 年 12 月**
- **初次发表：2022 年 9 月**
- **正式开源日期：2026 年 9 月**

## 项目愿景

我（Lawliet）从大三时开始开发本项目，并于 2023 年交由玩家“长尾”继续维护，前后持续了五年。虽然项目并未取得多大成绩，但我认为，这些年的开发与维护经历能为后来的开发者提供许多可供参考的经验。

项目在 Dota 2 游廊中的[主版本](https://steamcommunity.com/sharedfiles/filedetails/?id=2867620517)已开通全存档。

欢迎其他开发者自由使用本项目，开发自己的分支版本。使用时请注明[原项目地址](https://github.com/LGDLawliet/HeroicRoad)与原作者及所有者 **Lawliet**，并保留原有版权与许可声明。

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

## 本地存档

仓库已包含作者存档，克隆后无需额外生成或复制存档文件：

- `game/herodefense/scripts/vscripts/internal/local_archive_data.lua`：游戏启动时直接加载的存档模板。
- `game/herodefense/resource/作者存档.json`：对应的原始 JSON 存档。

模板保留作者的技能、符石、外观、特权和自定义玩法进度。每位玩家在运行时获取独立的局内副本；它不代表新玩家的初始平衡配置。

## 在 Workshop Tools 中使用

推荐使用目录链接工具创建 Windows 目录联接（Junction），将工程保存在独立的 Git 仓库目录中，让 Dota 2 Workshop Tools 直接读取同一份文件。修改代码或资源后，在仓库目录正常执行 Git 提交和同步即可。

1. 在目录链接工具中选择“目录联接 / Junction”，按下表创建链接。链接创建在 Dota 2 安装目录内，指向克隆下来的仓库目录。

   | 链接创建位置（Dota 2 安装目录下） | 指向的实际目录（仓库根目录下） |
   | --- | --- |
   | `content/dota_addons/herodefense` | `content/herodefense` |
   | `game/dota_addons/herodefense` | `game/herodefense` |

   如果链接创建位置已有同名目录，请先备份并移走该目录，再创建链接。

2. 启动 Dota 2 Workshop Tools，选择 `herodefense`。默认地图是 `camp_defense`，地图源文件位于仓库的 `content/herodefense/maps/camp_defense.vmap`。
3. 修改地图或资源后，使用 Workshop Tools 编译并运行地图；在仓库中查看变更并提交。

仓库中的 `content/herodefense` 和 `game/herodefense` 保持为实际工程目录；Dota 2 安装目录中的 Junction 仅用于本机连接，不需要提交到 Git。

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


## 社区交流（中国区）

中国区的玩家和开发者也可以加入 QQ 讨论群。一号群以玩家交流为主，**开发者建议加入二号群**。

| 群聊 | 群号 | 交流方向 | 加入方式 |
| --- | --- | --- | --- |
| 内卷之路一号群 | `260615782` | 玩家交流、玩法讨论 | [点击加入](http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=5Q8bOeNQJrFqCD-8ZBe3acVXVMttH2QZ&authKey=kbHjKdnrT0PDxRTn4Kz9jlL3opsD6QFCyTYAwhTxaCXx61eGUbcRafUl9dfuvEae&noverify=0&group_code=260615782) |
| 内卷之路二号群 | `758836738` | 开发交流与讨论，**开发者推荐** | [点击加入](http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=OvyIC3zGMYkEwIwx2Tu6YQnjL82I2tU_&authKey=EnHIcKeeuiLlMNQwUZ8ULlw6fesFB1DzbhJuuAbIoKefYJtUrmbV0YL2lxOejyCh&noverify=0&group_code=758836738) |

## 问题反馈

开发或使用过程中遇到问题，请通过 [GitHub Issues](https://github.com/LGDLawliet/HeroicRoad/issues) 反馈。提交前请先搜索已有 Issue，避免重复报告。

提交时请尽量说明使用的版本或提交编号、复现步骤、预期结果与实际表现，并附上相关报错日志或截图，方便定位和讨论。

## 素材版权说明

本项目包含部分缺乏明确版权授权的音效、图片等资源，可能涉及版权风险。**请自行替换项目中的非 Dota 2 资源，使用具有合法授权的素材。**

部分素材购自 **Fab 商城、Unity Asset Store、ArtStation** 等平台。**如需使用这些素材，请自行购买相应资源或授权，并遵守其许可条款。** 这些素材不随本项目的 MIT 开源许可一并授权。

具体模型、音效和图片的来源及授权说明，见[素材来源与版权清单](THIRD_PARTY_NOTICES.md#素材来源清单)。

## 许可证

项目原创代码与文档使用 [MIT License](LICENSE)。Dota 2 / Valve 内容及其他第三方代码和素材保留各自权利与授权条件，详见 [第三方说明](THIRD_PARTY_NOTICES.md)。

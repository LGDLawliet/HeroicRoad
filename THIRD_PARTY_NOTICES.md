# 第三方内容与素材

简体中文 | [English](THIRD_PARTY_NOTICES.en.md)

根目录的 MIT 许可证适用于本项目作者有权授权的原创代码和文档。

本项目包含部分缺乏明确版权授权的音效、图片等资源，可能涉及版权风险。**请自行替换项目中的非 Dota 2 资源，使用具有合法授权的素材。**

部分素材购自 **Fab 商城、Unity Asset Store、ArtStation** 等平台。**如需使用这些素材，请自行购买相应资源或授权，并遵守其许可条款。** 这些素材不随本项目的 MIT 开源许可一并授权。

- Dota 2、Source 2 及 Valve 提供的角色、模型、贴图、音效、工具和其他内容，其权利归各自权利人所有；本项目的 MIT 许可证不对这些内容授予额外权利。
- `content/` 和 `game/` 中的美术、音频、地图素材，以及其他第三方内容，不因放入本仓库而自动获得 MIT 授权。使用、修改或再分发时应核对其原始来源和授权条件。
- 随项目提供的第三方代码保留原有版权和许可证声明；`package.json` 中的依赖遵循各自许可证。

本文件不代表已完成所有历史素材的来源与授权核验。如需报告遗漏的来源、署名或授权问题，请在本仓库提交 Issue，并提供对应文件路径及来源信息。

## 素材来源清单

以下信息由项目作者提供，用于定位素材来源，不代表已完成逐项授权核验。商品链接或作者的购买记录不向本仓库使用者转授素材授权；如需使用付费素材，请自行购买相应资源或授权。

### 路径约定

以下路径均相对于 Addon 根目录 `herodefense/`，省略了仓库中的 `content/` 或 `game/` 前缀：

- `models/…/*.vmdl` 为模型源文件，位于 `content/herodefense/` 下；对应的编译资源位于 `game/herodefense/` 下。
- `sounds/` 和 `panorama/images/` 项目按相同相对路径定位 `content/herodefense/` 与 `game/herodefense/` 中的源素材或运行资源。
- 目录项包含其子目录中的对应资源；`models/custom/` 下的 Unity 素材范围仅指下表注明的植物、石头及具体目录。
- `sco_crab.vmdl`、`emental.vmdl`、`soud_wheel/` 等拼写与项目实际文件一致。

### Fab 模型

| 模型路径 | 商品来源 |
| --- | --- |
| `models/creeps/goblin/goblin.vmdl` | [Fab 商品页](https://www.fab.com/listings/57431774-6db0-4f31-b1c4-0d9ca5e12e3a) |
| `models/creeps/mutant_croc/mutant_croc.vmdl` | [Fab 商品页](https://www.fab.com/listings/2b72e31a-39dd-49df-8c01-e5ccf63f7e49) |

### 机械系列模型

来源：[Fab 商家 Shumniy](https://www.fab.com/sellers/Shumniy)。此链接为商家主页，具体模型商品及授权需自行核对。

- `models/eom/lawliet/sci_blue_whale/sci_blue_whale.vmdl`
- `models/eom/lawliet/sci_cat/sci_cat.vmdl`
- `models/eom/lawliet/sci_crab/sco_crab.vmdl`
- `models/eom/lawliet/sci_dragon/sci_dragon.vmdl`
- `models/eom/lawliet/sci_snake/sci_snake.vmdl`

### Unity Asset Store 素材

原购买账号已丢失，作者无法在此提供具体商品出处。请自行查找对应商品，并购买所需资源或授权。

- `models/monster/cyclops/cyclops.vmdl`
- `models/monster/acsu_atlus/acsu_atlus.vmdl`
- `models/monster/demon/demon_1/little_demon.vmdl`
- `models/monster/giant_crab/giant_crab.vmdl`
- `models/monster/golem/rock_golem.vmdl`
- `models/monster/harpy/sk_harpy.vmdl`
- `models/monster/monster_1/monster_001.vmdl`
- `models/monster/troll/troll.vmdl`
- `models/monster/werewolf/werewolf.vmdl`
- `models/custom/creeps/golem/golem.vmdl`
- `models/custom/creeps/golem/golem_lava.vmdl`

| 目录 | 涉及素材 |
| --- | --- |
| `models/custom/` | 其中的植物、石头素材 |
| `models/custom/hd_props/` | 该目录下的资产 |
| `models/custom/rock/` | 该目录下的资产 |

### 元素体模型

来源：[Fab 商品页](https://www.fab.com/listings/63854912-29ae-45ec-bb9e-0bde96b211a4)。作者说明 Unity Asset Store 也有对应资源，未提供具体链接，需要使用者自行查找并核对。

- `models/monster/element/air/air_emental.vmdl`
- `models/monster/element/earth/earth_emental.vmdl`
- `models/monster/element/holy/holy_degenerate_emental.vmdl`
- `models/monster/element/holy/holy_emental.vmdl`
- `models/monster/element/lava/lava_emental.vmdl`
- `models/monster/element/magicelemental/magicelemental.vmdl`
- `models/monster/element/molten/molten_emental.vmdl`
- `models/monster/element/shadow/shadow_emental.vmdl`
- `models/monster/element/shadow/shadow_metal_emental.vmdl`
- `models/monster/element/water/water_emental.vmdl`

### Fab AI 产品

| 目录 | 来源说明 |
| --- | --- |
| `panorama/images/custom_game/chaotic_era/rune/` | 作者标注为来自 Fab 的 AI 产品；暂未提供具体商品链接，请自行核对商品来源与授权。 |

### 授权不明确、需要自行核对或替换的资源

作者原清单中的“无版权”在此表示未提供明确授权依据，**不表示素材属于公有领域或可自由使用**。以下清单包括但不限于：

| 路径或目录 | 说明 |
| --- | --- |
| `models/monsters/monster00123/monster00123.vmdl` | 未提供明确授权依据，请自行替换或确认授权。 |
| `models/monsters/monster00127/monster00127.vmdl` | 未提供明确授权依据，请自行替换或确认授权。 |
| `models/monsters/monster00129/monster00129.vmdl` | 未提供明确授权依据，请自行替换或确认授权。 |
| `sounds/spell/` | 该目录下的全部音效未提供明确授权依据。 |
| `sounds/soud_wheel/` | 该目录下的全部音效；作者说明均为朋友的声音。使用或再分发前，请自行确认录音使用授权。 |
| `panorama/images/custom_game/chaotic_era/PlayerArtifact/` | 该目录下的全部文件未提供明确授权依据。 |
| `panorama/images/custom_game/chaotic_era/hud/game_effect/` | 该目录下的文件未提供明确授权依据。 |
| `panorama/images/custom_game/chaotic_era/hud/artifact/` | 作者说明部分图片来自《Artifact》；请自行甄别具体图片及其适用授权，不应将整个目录视为可自由使用。 |

如能补充商品链接、来源或授权信息，请通过 [GitHub Issues](https://github.com/LGDLawliet/HeroicRoad/issues) 提供对应文件路径与依据。

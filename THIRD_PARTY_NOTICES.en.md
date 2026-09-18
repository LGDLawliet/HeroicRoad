# Third-party content and assets

[简体中文](THIRD_PARTY_NOTICES.md) | English

The MIT License at the repository root applies to original code and documentation that the project authors have the right to license.

Some audio, images, and other assets in this project lack clear copyright authorization and may pose copyright risks. **Please replace non-Dota 2 assets with assets you are licensed to use.**

Some assets were purchased from **Fab, the Unity Asset Store, ArtStation**, and other marketplaces. **If you wish to use these assets, purchase the relevant assets or licenses yourself and comply with their license terms.** These assets are not covered by this project's MIT License.

- Dota 2, Source 2, and characters, models, textures, audio, tools, and other content provided by Valve remain the property of their respective rights holders. This project's MIT License grants no additional rights to that content.
- Artwork, audio, map assets, and other third-party content under `content/` and `game/` do not automatically become MIT-licensed by being included in this repository. Check their original sources and license terms before using, modifying, or redistributing them.
- Bundled third-party code retains its original copyright and license notices. Dependencies listed in `package.json` are governed by their own licenses.

This notice does not mean that the provenance and licensing of every historical asset have been verified. To report a missing source, attribution, or licensing issue, please open an issue in this repository with the relevant file path and source information.

## Asset source inventory

The following information was provided by the project author to help identify asset sources. It is not a completed asset-by-asset license audit. Product links and the author's purchases do not transfer asset licenses to repository users; purchase the relevant assets or licenses yourself if you wish to use paid assets.

### Path conventions

All paths below are relative to the `herodefense/` addon root, omitting the repository's `content/` or `game/` prefix:

- Model source files listed as `models/…/*.vmdl` are under `content/herodefense/`; their compiled counterparts are under `game/herodefense/`.
- For `sounds/` and `panorama/images/`, use the same relative path under `content/herodefense/` or `game/herodefense/` to locate source or runtime assets.
- Directory entries include the relevant assets in their subdirectories. The Unity assets under `models/custom/` are limited to the plants, rocks, and specific directories noted below.
- Spellings such as `sco_crab.vmdl`, `emental.vmdl`, and `soud_wheel/` match the actual project files.

### Fab models

| Model path | Source |
| --- | --- |
| `models/creeps/goblin/goblin.vmdl` | [Fab listing](https://www.fab.com/listings/57431774-6db0-4f31-b1c4-0d9ca5e12e3a) |
| `models/creeps/mutant_croc/mutant_croc.vmdl` | [Fab listing](https://www.fab.com/listings/2b72e31a-39dd-49df-8c01-e5ccf63f7e49) |

### Mechanical models

Source: [Shumniy on Fab](https://www.fab.com/sellers/Shumniy). This is the seller's page; identify the individual products and check their licenses yourself.

- `models/eom/lawliet/sci_blue_whale/sci_blue_whale.vmdl`
- `models/eom/lawliet/sci_cat/sci_cat.vmdl`
- `models/eom/lawliet/sci_crab/sco_crab.vmdl`
- `models/eom/lawliet/sci_dragon/sci_dragon.vmdl`
- `models/eom/lawliet/sci_snake/sci_snake.vmdl`

### Unity Asset Store assets

The author has lost access to the original purchasing account and cannot provide the individual product links here. Locate the corresponding products and purchase the required assets or licenses yourself.

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

| Directory | Relevant assets |
| --- | --- |
| `models/custom/` | Plants and rocks within this directory |
| `models/custom/hd_props/` | Assets within this directory |
| `models/custom/rock/` | Assets within this directory |

### Elemental models

Source: [Fab listing](https://www.fab.com/listings/63854912-29ae-45ec-bb9e-0bde96b211a4). The author notes that corresponding assets are also available on the Unity Asset Store, but no specific links were provided. Locate and verify them yourself.

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

### AI products from Fab

| Directory | Source information |
| --- | --- |
| `panorama/images/custom_game/chaotic_era/rune/` | Identified by the author as AI products from Fab. No specific product link was provided; verify the source and license yourself. |

### Assets with unclear authorization: verify or replace

The author's original label “无版权” is used here to mean that clear evidence of permission has not been provided. **It does not mean the assets are in the public domain or free to use.** This list includes, but is not limited to:

| Path or directory | Notes |
| --- | --- |
| `models/monsters/monster00123/monster00123.vmdl` | No clear authorization provided; replace the asset or confirm permission. |
| `models/monsters/monster00127/monster00127.vmdl` | No clear authorization provided; replace the asset or confirm permission. |
| `models/monsters/monster00129/monster00129.vmdl` | No clear authorization provided; replace the asset or confirm permission. |
| `sounds/spell/` | No clear authorization was provided for any sound files in this directory. |
| `sounds/soud_wheel/` | All sound files in this directory; the author states these are friends' voices. Confirm permission to use or redistribute the recordings. |
| `panorama/images/custom_game/chaotic_era/PlayerArtifact/` | No clear authorization was provided for any files in this directory. |
| `panorama/images/custom_game/chaotic_era/hud/game_effect/` | No clear authorization was provided for the files in this directory. |
| `panorama/images/custom_game/chaotic_era/hud/artifact/` | The author notes that some images come from Artifact. Identify the individual images and verify the applicable permissions; do not treat the entire directory as freely usable. |

To contribute product links, source information, or licensing evidence, please open a [GitHub issue](https://github.com/LGDLawliet/HeroicRoad/issues) with the relevant file paths and supporting information.

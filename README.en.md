# Heroic Road:Chaotic Era.2.1G

[简体中文](README.md) | English

A Dota 2 custom game project. The addon is named `herodefense`, and its default map is `camp_defense`.

This version uses a local Lua save adapter for the existing backend interfaces. Login, settlement, runes, and other supported operations are handled within the game session, without the original online backend.

## Project version

- **Version: Heroic Road:Chaotic Era.2.1G**
- **Development began: December 2021**
- **First published: September 2022**
- **Official open-source release: September 2026**

## Project vision

I (Lawliet) started developing this project during my junior year at university. In 2023, I handed its maintenance over to a player known as 长尾 (Changwei). Development and maintenance spanned five years in total. Although the project never achieved much success, I believe the experience gained along the way can offer useful lessons for future developers.

The [main version on the Dota 2 Arcade](https://steamcommunity.com/sharedfiles/filedetails/?id=2867620517) now offers fully unlocked save data.

Other developers are welcome to use this project to develop their own forks. Please credit the [original project](https://github.com/LGDLawliet/HeroicRoad) and its original author and owner, **Lawliet**, and retain the existing copyright and license notices.

## Project structure

| Path | Contents |
| --- | --- |
| `game/herodefense/scripts/vscripts/` | Lua game logic; the server entry point is `addon_game_mode.lua` |
| `game/herodefense/scripts/npc/` | KeyValues configuration for units, abilities, items, and other game content |
| `game/herodefense/` | Runtime addon files and compiled Source 2 resources |
| `content/herodefense/` | Source assets for maps, models, materials, effects, and Panorama |
| `content/herodefense/panorama/` | XML, JavaScript, and CSS/LESS UI source files |
| `工具/tool_scripts/` | Historical helper tools and documents |

## Getting the project

You need Git, Git LFS, and Dota 2 with Dota 2 Workshop Tools installed. The project includes a substantial collection of assets, so allow enough disk space for the download.

```powershell
git lfs install
git clone https://github.com/LGDLawliet/HeroicRoad.git
cd HeroicRoad
git lfs pull
```

Textures, models, audio, and other assets are managed with Git LFS. Use the Git commands above to obtain the actual assets rather than LFS pointer files.

## Local save data

The author's save data is included in the repository. No additional command is needed to generate or copy save files after cloning:

- `game/herodefense/scripts/vscripts/internal/local_archive_data.lua`: the save template loaded directly when the game starts.
- `game/herodefense/resource/作者存档.json`: the corresponding original JSON save data.

The template preserves the author's skills, runes, cosmetics, privileges, and custom progression. Each player receives an independent copy for the current session. This template does not represent the intended starting balance for a new player.

## Using the project with Workshop Tools

We recommend using a directory linking tool to create Windows directory junctions. Keep the project in its own Git repository directory and let Dota 2 Workshop Tools access the same files through those links. After editing code or assets, commit and sync changes from the repository as usual.

1. Select the directory junction option in your linking tool and create the links below. The links belong inside the Dota 2 installation and point to the cloned repository.

   | Link location, relative to the Dota 2 installation | Target directory, relative to the repository root |
   | --- | --- |
   | `content/dota_addons/herodefense` | `content/herodefense` |
   | `game/dota_addons/herodefense` | `game/herodefense` |

   If a directory already exists at either link location, back it up and move it aside before creating the junction.

2. Launch Dota 2 Workshop Tools and select `herodefense`. The default map is `camp_defense`; its source is at `content/herodefense/maps/camp_defense.vmap` in the repository.
3. After modifying a map or asset, compile and run it with Workshop Tools, then review and commit the changes in the repository.

Keep `content/herodefense` and `game/herodefense` in the repository as actual project directories. Junctions inside the Dota 2 installation are local connections and do not need to be committed to Git.

## Local backend interfaces

`GAME_server_address = "http://local-archive/"` is only a route prefix. There is no need to configure that hostname or start an HTTP service:

```text
Game logic → LocalArchive.CreateRequest → Local save logic → Original callback
```

- `internal/local_archive.lua` handles request compatibility and dispatch.
- `internal/local_archive_store.lua` handles data and supported operations within the current session.
- Each player receives an independent copy of the template, with their Steam identity bound at runtime.
- Settlement, purchases, and other changes remain in session memory and are not written back to the save files. A new session reloads the template.
- Unsupported online operations return a failure. There is no fallback to the original backend.


## QQ community (China)

Players and developers in China can also join the QQ discussion groups below. Group 1 is primarily for players; **developers are encouraged to join Group 2**.

| Group | QQ group number | Focus | Join |
| --- | --- | --- | --- |
| 内卷之路一号群 (Group 1) | `260615782` | Player community and gameplay discussion | [Join group](http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=5Q8bOeNQJrFqCD-8ZBe3acVXVMttH2QZ&authKey=kbHjKdnrT0PDxRTn4Kz9jlL3opsD6QFCyTYAwhTxaCXx61eGUbcRafUl9dfuvEae&noverify=0&group_code=260615782) |
| 内卷之路二号群 (Group 2) | `758836738` | Development discussion; **recommended for developers** | [Join group](http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=OvyIC3zGMYkEwIwx2Tu6YQnjL82I2tU_&authKey=EnHIcKeeuiLlMNQwUZ8ULlw6fesFB1DzbhJuuAbIoKefYJtUrmbV0YL2lxOejyCh&noverify=0&group_code=758836738) |

## Reporting issues

If you encounter a problem while developing or using the project, please report it through [GitHub Issues](https://github.com/LGDLawliet/HeroicRoad/issues). Search existing issues before opening a new one to avoid duplicate reports.

Please include the version or commit you are using, steps to reproduce the problem, the expected and actual behavior, and any relevant error logs or screenshots to help with investigation and discussion.

## License

Original project code and documentation are released under the [MIT License](LICENSE). Dota 2 / Valve content and other third-party code and assets retain their respective rights and license terms. See the [third-party notices](THIRD_PARTY_NOTICES.en.md).

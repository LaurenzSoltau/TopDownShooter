# Top Down Shooter

A wave-based top-down shooter built with **Godot 4** (GDScript, Forward+ renderer).

Survive waves of enemies, collect money and XP, level up to pick stat upgrades, and buy
new weapons from the vendor between fights.

## Features

- **Wave system** — each wave is configured with per-enemy-type counts and a spawn interval;
  enemies spawn along a `Path2D` around the arena and the next wave starts once the map is clear.
- **Enemies** — melee and ranged variants that drop money and XP on death.
- **Weapons** — pistol, machine gun and shotgun, all derived from a shared base ranged weapon.
- **Progression** — level-up upgrades (max health, health regen, damage, ranged damage,
  attack range), each with its own tier scaling.
- **Vendor / shop** — walk up to the NPC and press `E` to open the weapon shop and spend money.
- **UI** — inventory, stat screen, upgrade overlay, damage indicators, pause overlay,
  main menu and end screen.

## Controls

| Action | Key |
| --- | --- |
| Move | `W` `A` `S` `D` |
| Shoot | Mouse (aim + fire) |
| Interact / open shop | `E` |
| Stats | `Tab` |
| Pause | `Space` |
| Close overlay | `Esc` |

## Running the project

1. Install [Godot 4](https://godotengine.org/download).
2. Open Godot, click **Import**, and select `project.godot` from this folder.
3. Press **F5** to run — the game starts at `Screens/main_menu_screen.tscn`.

## Project layout

| Folder | Contents |
| --- | --- |
| `Player/` | Player scene, movement and shooting |
| `Enemies/` | Enemy scenes, bullets, money drops |
| `Waffen/` | Weapons (German: *Waffen*) |
| `WaveSystem/` | Wave definitions and the spawner |
| `Npc/` | Vendor NPC |
| `UserInterface/` | HUD, shop, inventory and overlays |
| `Screens/` | Main menu, game and end screen |
| `AutoLoad/` | Global singletons (`WeaponScenes`, `GlobalSound`) |
| `Assets/` | Textures, themes and `Resource` files (stats, inventory, upgrades) |

## License

MIT — see [LICENSE](LICENSE).

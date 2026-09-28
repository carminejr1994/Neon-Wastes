# Neon Wastes — Android Offline Loot-Shooter

A clean-room, original vertical-slice project inspired by the *broad* visual language and gameplay conventions of comic-book cel-shaded loot shooters.

**Important IP boundary:** this repository does **not** contain Borderlands/Gearbox character art, concept art, logos, audio, maps, dialogue, extracted game data, or pre-release artwork. The visual assets here are newly authored and intentionally use a distinct original cast/setting.

## What is included

- Godot 4 project
- Offline single-player arena shooter
- Keyboard/mouse controls for development
- Basic Android touch handling
- Enemies, health, ammo, pickups, score, progression
- Original SVG splash/icon and procedural vector art
- No network dependency at runtime
- GitHub Actions workflow that exports an APK
- Codespaces-friendly build script

## Build in GitHub Codespaces

```bash
./tools/build_android.sh
```

The script installs/uses a pinned Godot binary in `/tmp` and exports:

`build/neon-wastes-debug.apk`

The GitHub Actions workflow performs the same export in CI and uploads the APK as a workflow artifact.

## Development

Open the folder in Godot 4.4+.

Desktop:
- WASD / arrows: move
- Hold left mouse: fire

Android:
- left-side drag: movement
- right-side touch: firing

## Next production steps

1. Replace procedural placeholder geometry with original commissioned sprites/models.
2. Add weapon inventory and randomized affixes.
3. Add multiple handcrafted arenas and boss encounters.
4. Add save/load using local encrypted files if desired.
5. Add Android haptics and configurable touch controls.
6. Add release keystore secrets to GitHub Actions; never commit the keystore.

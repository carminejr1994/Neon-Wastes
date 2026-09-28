# Agent instructions

## Mission
Turn this starter vertical slice into a polished offline Android loot-shooter while preserving the clean-room IP boundary.

## Non-negotiable IP rule
Do not add or fetch Borderlands/Gearbox proprietary assets, leaked pre-release concept art, extracted game files, trademarks used as branding, character likenesses, dialogue, maps, textures, sounds, or code. Do not use leaked/pre-release art as a direct reference for asset recreation.

Allowed:
- Broad genre conventions
- Original comic/cel-shaded rendering
- Original characters, factions, weapons, environments, names, lore
- Publicly licensed or newly commissioned assets with compatible licenses

## Technical goals
- Godot 4.x
- Android ARM64
- Fully playable without network access after installation
- 60 FPS target on midrange Android hardware
- Touch controls with adjustable dead zones
- Local save only
- No analytics, ads, or network permissions unless explicitly added later

## Suggested roadmap
Phase 1: stabilize input, collision, enemy AI, object pooling.
Phase 2: weapon framework, projectile hitscan, loot tables, inventory UI.
Phase 3: procedural modifiers, 3 arenas, elite enemies, boss.
Phase 4: save system, settings, haptics, accessibility.
Phase 5: optimization, device testing, release signing.

## Build
`./tools/build_android.sh`

## Acceptance
A successful change must run in Godot and export an installable debug APK.

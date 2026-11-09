# This mod likely will not be maintained

I no longer really play the game, so ongoing updates and fixes are unlikely.

# Instant Victory Reveal

Fast-forwards victory XP, kill counters and short reveal delays without changing rewards.

<!-- drh:show -->
Fast-forwards victory XP, kill counters and short reveal delays without changing rewards.
<!-- /drh:show -->

- Fast-forwards XP, team XP, kill-count, treasure and booster reveal steps.
- Keeps normal loot controls and the separate trophy presentation.
- Does not change earned rewards or automatically leave the results screen.

## Requirements

Dungeon Rampage Haxe V17 and DRH Mod API 1.2 or a compatible later 1.x release. The launcher resolves the API dependency. This mod uses game internals and may need updates for later game releases.

## Installation

Install the release ZIP through the DRH Launcher Mods page. Do not use GitHub's automatic source-code ZIP as the release artifact.

To test a source checkout, run this from its repository folder with your launcher path:

```powershell
& "C:\Path\To\DRH-Launcher.com" --run-mod (Get-Location).Path
```

## Publishing

The included official workflow drafts a release when you push a `v<version>` tag matching `mod.json`. Test the generated ZIP before publishing the draft. Follow [Making a mod](https://github.com/Tutez64/Dungeon-Rampage-Haxe/blob/master/docs/making-a-mod.md) to submit the published release to the mod index.

## License

MIT. See [LICENSE](LICENSE).

# Just hyprtonation

A vibraphone for [hypr-dwm-land](https://github.com/Person1873/hypr-dwm-land). Each tag is a
note. Viewing plays what you see: one tag, one note; several, the chord. Viewing all plays the
populated tags in order. An urgent window strikes a chord that wants its tag's chord and is
left hanging; the tag's chord follows when the tag is viewed.

## Why

You hear which tag you landed on without looking up; after a day the nine pitches are as
familiar as a phone's tones, and a pair of tags you keep together has a sound of its own.
An urgent window is heard at the edge of attention, by pitch, without a glance at the bar,
and the figure does not finish until you go there. Viewing all is a census of the desk in
half a second.

## Install

An Omarchy plugin of kind `service`: enabling it starts the player, disabling it stops it.

```sh
omarchy pkg add fluidsynth soundfont-fluid      # the synthesizer; not installed by the plugin
omarchy plugin add https://github.com/Person1873/just-hyprtonation.git --enable
```

It needs hypr-dwm-land running, and reads its line on Hyprland's event socket
(`custom>>hyprdwmland>><monitor>|v=…|o=…|u=…|f=…`). It changes nothing.

## Tuning

| tag | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|
| ratio | 1 | 9/8 | 5/4 | 4/3 | 3/2 | 5/3 | 15/8 | 2 | 9/4 |

Tags 10..21 (the F-keys in hypr-dwm-land's dwm map): 25/24, 75/64, 45/32, 25/16, 225/128,
25/12, 75/32, 45/16, 25/8, 225/64, 25/6, 75/16.

`just-hyprtonation layout laptop` tunes the F-keys to where they sit on a laptop: F*n* is the
key between white *n* and *n*+1, the sharp where the piano has one; where it has none (F3, F7,
F10) the note completes the black keys' own scale, so F1..F7 are a just major scale on the
sharpened tonic.

Issues and PRs adjusting tuning will be closed as "Won't fix".

## Instruments

Vibraphone, cello, glass, organ, saw, dulcimer, tubular bells, handbells. The player's command
is `~/.config/omarchy/plugins/person1873.just-hyprtonation/bin/just-hyprtonation`; the running
instance takes:

```sh
just-hyprtonation instrument handbell   # or next | prev
just-hyprtonation pick                  # choose from a menu (Omarchy)
just-hyprtonation status                # the current instrument
just-hyprtonation layout piano|laptop
just-hyprtonation mute                  # toggle
```

The instrument and layout are remembered in `~/.local/state/just-hyprtonation/`.

A key for the picker, in `~/.config/hypr/bindings.lua`:

```lua
o.bind("SUPER + ALT + I", "Hyprtonation instrument", "~/.config/omarchy/plugins/person1873.just-hyprtonation/bin/just-hyprtonation pick")
```

[examples/omarchy-menu.jsonc](examples/omarchy-menu.jsonc) adds a Hyprtonation submenu to
the Omarchy menu, with mute and one row per instrument, the current one ticked; merge it into
`~/.config/omarchy/extensions/omarchy-menu.jsonc`.

## Jam

`SUPER + ALT + M` enters a Hyprland submap in which the tag keys play and move nothing:
1..9 and F1..F12 sound the tag, 0 the tenth white key, SHIFT + key the triad on that scale
degree; on the cello, organ, saw and glass a note lasts as long as the key is down. `-` and
`=` move the key by a semitone (a tone with SHIFT), ESCAPE leaves. From
`~/.config/hypr/bindings.lua`, after the hypr-dwm-land keys:

```lua
dofile(os.getenv("HOME") .. "/.config/omarchy/plugins/person1873.just-hyprtonation/hypr/jam.lua")
```

The key is at the top of [hypr/jam.lua](hypr/jam.lua).

## Without the plugin

`bin/just-hyprtonation` runs on its own from any checkout, for a bar other than the Omarchy
shell or for `o.launch_on_start` in `autostart.lua`. Options: `--instrument`, `--layout`,
`--monitor NAME`, `--tonic MIDI`, `--soundfont PATH` (default
`/usr/share/soundfonts/FluidR3_GM.sf2`), `--audio-driver` (default `pipewire`),
`--backend dry` (prints what it would play), `--muted`, `stop`.

## Removing

```sh
omarchy plugin remove person1873.just-hyprtonation
# then delete the jam `dofile` line and the picker bind from ~/.config/hypr/bindings.lua,
# and the "hyprtonation" rows from ~/.config/omarchy/extensions/omarchy-menu.jsonc, if added.
rm -r ~/.local/state/just-hyprtonation          # the remembered instrument and layout
```

## Dependencies

- hypr-dwm-land, running.
- `fluidsynth` and `soundfont-fluid` (Arch `extra`); `omarchy pkg add fluidsynth soundfont-fluid`.
  Not installed by this plugin.
- `python3` (present on Omarchy).

## License

MIT. See [AUTHORSHIP.md](AUTHORSHIP.md).

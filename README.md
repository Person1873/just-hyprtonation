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

## Tuning

| tag | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|
| ratio | 1 | 9/8 | 5/4 | 4/3 | 3/2 | 5/3 | 15/8 | 2 | 9/4 |

Tags 10..21 (the F-keys in hypr-dwm-land's dwm map): 25/24, 75/64, 45/32, 25/16, 225/128,
25/12, 75/32, 45/16, 25/8, 225/64, 25/6, 75/16.

`--layout laptop` tunes the F-keys to where they sit: F*n* is the key between white *n* and
*n*+1, the sharp where the piano has one and the quarter-tone between the whites where it
has none (F3, F7, F10).

Issues and PRs adjusting tuning will be closed as "Won't fix".

## Running

```sh
bin/just-hyprtonation                       # vibraphone via fluidsynth, first monitor
bin/just-hyprtonation --backend dry         # prints what it would play
bin/just-hyprtonation --muted               # start silent
bin/just-hyprtonation mute                  # toggle the running instance
bin/just-hyprtonation instrument handbell   # change the running instance's instrument
bin/just-hyprtonation instrument next       # or prev
bin/just-hyprtonation pick                  # choose from a menu (Omarchy)
bin/just-hyprtonation status                # the current instrument
bin/just-hyprtonation stop
```

On Omarchy, from `~/.config/hypr/autostart.lua` and `bindings.lua`:

```lua
o.launch_on_start("~/just-hyprtonation/bin/just-hyprtonation")
o.bind("SUPER + ALT + I", "Hyprtonation instrument", "~/just-hyprtonation/bin/just-hyprtonation pick")
```

## Jam

`SUPER + ALT + M` enters a Hyprland submap in which the tag keys play and move nothing:
1..9 and F1..F12 sound the tag, 0 the tenth white key, SHIFT + key the triad on that scale degree, `-` and `=`
move the key by a semitone (a tone with SHIFT), ESCAPE leaves. From
`~/.config/hypr/bindings.lua`, after the hypr-dwm-land keys:

```lua
dofile(os.getenv("HOME") .. "/just-hyprtonation/hypr/jam.lua")
```

The key is at the top of [hypr/jam.lua](hypr/jam.lua).

## Omarchy menu

[examples/omarchy-menu.jsonc](examples/omarchy-menu.jsonc) adds a Hyprtonation submenu to
the Omarchy menu, with mute and one row per instrument, the current one ticked; merge it into
`~/.config/omarchy/extensions/omarchy-menu.jsonc`.

Options: `--instrument vibraphone|cello|glass|organ|saw|dulcimer|tubular|handbell`
(default: the last one picked, kept in `~/.local/state/just-hyprtonation/instrument`; vibraphone
before any pick), `--monitor NAME`, `--tonic MIDI` (default: the instrument's), `--soundfont PATH` (default
`/usr/share/soundfonts/FluidR3_GM.sf2`), `--audio-driver` (default `pipewire`), `--stdin`.

It reads hypr-dwm-land's line on Hyprland's event socket
(`custom>>hyprdwmland>><monitor>|v=…|o=…|u=…|f=…`) and changes nothing.

## Dependencies

- hypr-dwm-land.
- `fluidsynth` and `soundfont-fluid` (Arch `extra`); on Omarchy
  `omarchy pkg add fluidsynth soundfont-fluid`. Not installed by this program.

## License

MIT. See [AUTHORSHIP.md](AUTHORSHIP.md).

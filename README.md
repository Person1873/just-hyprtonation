# Just hyprtonation

A companion to [hypr-dwm-land](https://github.com/Person1873/hypr-dwm-land): every tag has
a note, changing tags plays it, viewing several tags together plays the chord, and the
notes are in **just intonation**, so the chords you build by putting windows on tags are
either pure or wolfish, and both are the point.

Status: design. No code yet. It will be a standalone process that reads hypr-dwm-land's
published bar protocol; the engine is not modified.

## What it does

- **Switch to a tag**, hear its note.
- **View several tags at once** (hold SUPER, press several), hear them as a chord. Because
  the scale is just, the 1-3-5 triad is exactly 4:5:6 and does not beat; other combinations
  are as sweet or as sour as their ratios make them. Where you keep your windows is a
  compositional choice.
- **View all** (`SUPER + 0`) arpeggiates the tags that have windows, low to high; going back
  plays the previous view's chord, so the reveal and the retreat sound different.
- **An urgent window** plays a short figure in that tag's key that does not resolve: two
  notes leaning toward the tag's own note, then silence. It repeats politely while ignored
  and resolves onto the tag's note the moment you view the tag, so the cadence completes
  when you answer the window. Two urgent tags are two unresolved figures a fixed interval
  apart; resolving one leaves the other hanging.
- A **mute** key and a startup default that will not interrupt a meeting.

## Tuning

Tag 1 is the tonic. The digits are the white keys of a just major scale, an octave plus a
second (nine white keys):

| tag | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|
| ratio | 1 | 9/8 | 5/4 | 4/3 | 3/2 | 5/3 | 15/8 | 2 | 9/4 |

The F-keys (tags 10..21 in hypr-dwm-land's dwm map) are the black keys above them. Just
intonation has no single answer for the sharps, and the choice decides which chords sing
and which howl: 25/24 for the C sharp is the "augmented" colour against a 5/4 E, 16/15 is
the wolf. The choice is deliberate and configurable; the wolfish chords are partly the
point. Issues and PRs adjusting tuning will be closed as "Won't fix".

Urgency figure, relative to the tag's own ratio *r*: *r* × 9/8, then *r* × 15/8 (a second
above and the leading tone below), then silence; resolution is *r* itself.

## How it hears tags

hypr-dwm-land writes one line per monitor on Hyprland's event socket whenever anything
changes:

```
custom>>hyprdwmland>>eDP-1|v=2,3|o=1:2,2:1,5:1|u=5|f=2
```

`v=` viewed tags, `o=` occupied tags with counts, `u=` urgent tags, `f=` tags of the focused
window. This program follows the socket, diffs each line against the last, and plays:
added viewed tags as notes (a chord when several arrive at once), the occupied set as an
arpeggio when the view becomes "all", and the urgency figure for tags newly present in `u=`.

## Sound

Cello first. A bowed attack lets a chord arrive rather than strike, a sustained tone lets
the urgency figure hang for as long as it is ignored, and the low register carries the
intervals as they are meant to be heard. Realised with a SoundFont through `fluidsynth`,
pitch bend placing each sampled note on its ratio. A second, plainer backend synthesises
tones once per ratio at startup and plays them through `pw-play`, for machines without a
SoundFont.

## Running it

```sh
bin/just-hyprtonation                       # cello via fluidsynth, first monitor
bin/just-hyprtonation --backend pwplay      # sine tones, no SoundFont needed
bin/just-hyprtonation --backend dry         # prints what it would play
bin/just-hyprtonation --muted               # start silent; SIGUSR1 toggles
```

On Omarchy, start it with the session from `~/.config/hypr/autostart.lua`:

```lua
o.launch_on_start("~/just-hyprtonation/bin/just-hyprtonation")
```

Options: `--monitor NAME` (default: the first monitor), `--tonic MIDI` (default 48, C3, where
a cello lives), `--soundfont PATH` (default `/usr/share/soundfonts/FluidR3_GM.sf2`),
`--audio-driver` (default `pipewire`). `--stdin` reads protocol lines from standard input, for
testing the music without a compositor.

## Dependencies

- [hypr-dwm-land](https://github.com/Person1873/hypr-dwm-land), whose socket line this
  program listens to. Without it there are no tags and nothing plays.
- `fluidsynth` (Arch `extra`, 2.6) and a General MIDI SoundFont with a cello;
  `soundfont-fluid` (FluidR3, Arch `extra`) is the default. On Omarchy:
  `omarchy pkg add fluidsynth soundfont-fluid`. Neither is installed by this program.
- `socat`, `jq`, and PipeWire's `pw-play` for the fallback backend; all ship with Omarchy.

## Origin

Conceived on 2026-09-08 by Person1873 while shipping hypr-dwm-land, as "a completely
unhinged idea". See [AUTHORSHIP.md](AUTHORSHIP.md).

## License

MIT.

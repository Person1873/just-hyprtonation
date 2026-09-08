# Authorship

Built with an AI assistant (Claude, Anthropic). This file separates the human's ideas from
the AI's contributions, and says what has been tested.

## Human-driven

- The idea: a companion to hypr-dwm-land where changing tags plays a just-intonated note
  and viewing tags together plays the chord; F-keys as the black keys above the white
  major scale.
- The wolfish chords are partly the point, not a defect to tune away.
- `SUPER + 0` (view all) arpeggiates the populated tags rather than playing one chord.
- Urgency as a three-note figure that does not resolve until the tag is viewed, resolving
  onto the tag's own base note so each urgent tag's figure is unique.

## AI-generated

- The design write-up in the README: the just ratios for the white keys, the observation
  that the sharps have no single just answer (25/24 versus 16/15), the 9/8 and 15/8 leaning
  notes for the urgency figure, the choice to consume hypr-dwm-land's published socket line
  rather than modify the engine, the two sound backends, the mute/startup caveat.
- All code: `bin/just-hyprtonation` (socket follower, tuning maths, chord/arpeggio/urgency logic, fluidsynth, pw-play and dry backends).

## Heard (2026-09-08)

fluidsynth 2.6 with FluidR3_GM over PipeWire, driven by the program: a single tag, a
two-tag chord, the view-all arpeggio and the retreat, on this machine's speakers, judged
by the human. Two things were wrong on first hearing and were fixed: a view reached by
adding one tag sounded as a single note (the chord now voices the whole view on every
change), and the arpeggio was muddy (notes shortened to 0.32 s, step widened to 0.17 s so
at most two ring together). The urgency figure has not yet been heard live.

The urgency figure was then heard and reshaped over eight rounds, each a human judgment:
two leaning notes ("insufficient to invoke tonality"), three (implied the key but did not
demand resolution), a hanging tritone, a rootless major seventh ("too consonant"), a
sharpened root, that plus a flat seventh (the fully diminished sound the human liked, but
symmetric and "wanting to go somewhere else"), a half-diminished version, and finally the
diminished seventh on the tag's leading tone, whose every voice is a step from the tag's
major triad. Then the attack: velocity alone was still a swell (the SoundFont's cello has a
slow onset at any velocity), a pizzicato patch struck but "reads as a different
instrument", so the strike channels keep the cello at full volume, doubled an octave
down, hit twice. Verdict: "hits like a train horn now, which I guess is the natural
conclusion to the direction I was pushing". Recorded as the intended sound. (This entry
originally also credited MIDI sound controllers, attack 0 and a longer release, brightness
and resonance up. They did nothing; see "Corrected" below. The sound the human approved was
level, doubling and the double hit.)

## Instruments (2026-09-08)

The human asked for "a bell organ: something that rings out but is light and bright, full
not warm". Auditioned in turn, each a human judgment: celesta ("sounds like a children's
toy", at two octaves; dropped), vibraphone ("warm where bells are full but bright"; kept),
tubular bells ("church bells, not what I'm chasing"; kept), glockenspiel ("that would work
with reverb and increased sustain"). The `handbell` instrument is that: the glockenspiel
patch with reverb send up (CC 91) and fluidsynth's reverb room set larger. (A raised release,
CC 72, was also sent and did nothing; see "Corrected".) Per-instrument controller and reverb hooks were added to carry it; the other
instruments keep fluidsynth's default reverb. The plain glockenspiel was then dropped as
indistinguishable from the handbell back to back.

Every instrument was then heard one at a time, the view sequence and the urgency figure,
and adjusted on the human's word: glass played softly (velocity 56, "reduced attack" meant
the hit, not the onset) with its strike at 70; the square wave replaced by a saw two octaves
down ("I like it for the meme"); the organ's strike "loud" led to a general strike ceiling of
80 for everything but the cello ("cello just isn't a super dynamic instrument in
comparison"), and the vibraphone's raised to 104 from there. The vibraphone became the
default: "doesn't ring out too much, cello felt a bit pompous". Dulcimer kept ("needs a
specific aether theme to go with it").

## Instrument switching (2026-09-08)

Asked for by the human ("a way to change instruments without having to re-launch"). The
`instrument NAME` subcommand writes the name beside the pidfile and sends `SIGUSR2`; the
instance reprograms every channel in place, restoring fluidsynth's default reverb and the
sound controllers first (CC 121 leaves those alone by the MIDI spec, so they are reset
explicitly). The tonic follows the instrument unless `--tonic` was given. Heard live:
vibraphone, handbell, saw, vibraphone, one tag each, with no relaunch; a bad name prints
the list and exits 1.

The human then called that "infrastructure, not integration", so: `pick` puts the list
through `omarchy-menu-select` with the current one ticked, `next`/`prev` cycle, `status`
prints the current name, the instance records its instrument at start, and
`examples/omarchy-menu.jsonc` gives the Omarchy menu a submenu whose rows tick the current
instrument through bash `checked:` conditions (verified in the shell's `MenuModel.js`, which
runs `when:` and `checked:` as bash). Tested: `next`/`prev`/`status` on the running
instance; the menu rows and the `SUPER + ALT + I` key were installed on the author's machine
and the config reloaded clean.

The pick is remembered across relaunches (the human: "on relaunch it should remember what
you last had picked"): a state file under `XDG_STATE_HOME`, written by `instrument`/`pick`
and by an explicit `--instrument`. Tested: start, pick handbell, stop, start again reports
handbell; an explicit `--instrument saw` both wins and becomes the saved choice.

## Jam mode (2026-09-08)

The human's idea: "there probably needs to be a jam mode where the keys just play without
throwing shit around". Built as a Hyprland submap (`hypr/jam.lua`) rather than anything in
the player: inside it the bare tag keys send `hyprtonation>>note|N` (SHIFT: `chord|N`) on
the event socket, which the player already reads, and the submap shadows the tag binds so
nothing moves. Semantics of `hl.define_submap` and bare-key binds were taken from the
Hyprland wiki's submaps page and the 0.56.2 source (`LuaBindingsToplevel.cpp`), not recalled.
Verified: config reloads clean, the submap lists 46 binds, the entry key is registered, and
note and chord events fired at the socket sound. The submap was not entered from the
keyboard by the AI; the human did that.

Then, the human's refinements: `-`/`=` transpose by a semitone, a tone with SHIFT (the new
tonic sounds as feedback; the transposition stays for tag sounds too until the program is
restarted), and SHIFT + key plays the triad on the scale degree, stacked thirds of the just
scale, so ii, iii and vi come out minor and vii diminished. And the human's observation that
on a laptop the F-keys sit evenly above the digits, unlike black keys: `--layout laptop`
puts F*n* between white *n* and *n*+1, the sharp where a black key exists and the geometric
mean of the two whites (a just quarter-tone) at E-F and B-C. The AI checked the table by
printing it (F3 at 442 cents between E 386 and F 498; F7 at 1144 between B 1088 and C 1200)
and fired note, chord and transpose events at the running player. The 0 key first played
the octave; the human noticed ("in jam mode, 0=8") and it is now the tenth scale degree,
which is where the laptop layout already put it.

The quarter-tones were judged flat ("F3 & F7 sound flat to me if we assume the blacks are
a major scale"), so the laptop layout now completes the black keys' own just major scale
instead: F3 is 125/96, the major third above F1, and F7 125/64, its major seventh; "works
as expected now". The fourth of that scale is 22 cents wide because F# stays 45/32.

Sustain: "for cello, saw, and organ, the note should cut off when we release the key".
Key down and key up are separate Hyprland binds; a sustaining instrument (flagged in the
table, glass too) holds the note between them and struck ones ignore the up. The human
found that rolling off a key while modifiers changed left notes hanging: a release bind
matches only the modifiers held at the press. The up bind now names the physical key,
ignores modifiers, and frees whatever that key started; leaving the submap releases all;
a 12 s cap catches anything else. The ignore-modifiers flag is not shown by `hyprctl
binds`, so it is verified only by the config accepting it and by the human's keyboard.

The human stopped here: "I'm going to stop short of having you build a looper. the fun
bit is done for all the polish it needs".

## Plugin packaging (2026-09-08)

The human: "need to prep this one ready to be another plugin". Read for it: the Omarchy
shell's plugin README and `PluginRegistry.qml` (kinds; `service` is a headless singleton
loaded while enabled and destroyed when disabled), `omarchy-plugin-validate`, `shell.qml`'s
service loader, a first-party service for the `Process` pattern, Quickshell's `Process`
type table, and the marketplace's SUBMISSION.md and SECURITY.md. So: `manifest.json` of kind
`service`, `shell/Service.qml` runs `bin/just-hyprtonation` as a Quickshell Process and
restarts it with a growing pause if it exits; instrument and layout are remembered under
`XDG_STATE_HOME` so the service takes no arguments; the jam submap and menu rows stay
opt-in, by their documented lines, since a plugin cannot reach into Hyprland config or the
menu. fluidsynth is documented, not installed. Tested on the author's machine: validate
passes; enabling starts the player and fluidsynth, a tag change sounds, disabling ends
both; a `kill -9` of the player is followed by a restart about four seconds later with no
orphaned fluidsynth; `stop` is likewise undone while enabled, as documented. The
preview image is generated by a short Pillow script the AI wrote (not kept in the repo).

## Stuck note watchdog (2026-09-08)

The human: "F6 seems to get stuck in jam mode sometimes", then "managed to trigger it, no
idea how". The release bind can miss when the key's symbol differs between press and
release; the trigger was not found. Instead `hypr/jam.lua` now keeps the pressed keys with
their keycodes and, while any is held, polls `hl.is_key_down(keycode)` every 60 ms (from
the 0.56.2 source: keycodes are evdev + 8) and sends the release itself when the key is
up; the release binds remain the fast path and the two deduplicate. Verified with the
human's keyboard on the event socket: F6 held 1.9 s produced one `on` and one `off` at the
release, taps of F6 and F5 paired cleanly. An attempt to test with wtype instead fired the
submap's Escape bind: Hyprland resolves a virtual keyboard's keycode through the real
keymap, where wtype's first keycode is Escape.

Latency: "the latency is weird" on the saw. Its onset went from about 30 ms to about 8 ms
(attack offset +3600 timecents) and fluidsynth's audio buffering from the default sixteen
64-frame periods to four, roughly 23 ms down to 6. Verdict by playing: "benny & the jets
becomes really easy on this". No crackle reported at the smaller buffer on the author's
machine; a machine that underruns should raise `-c`.

Marimba (GM 12, tonic C4) added at the human's request ("because I am a sucker for
crash bandicoot"); heard on the standard sequence and in jam, where the Bridal Chorus
"obviously has some off key chords", which the tuning stance covers.

Reselection (2026-09-08): "when I type a workspace number, and it's the one I'm already
on, it doesn't play the note, which immediately makes me feel like it didn't work". The
bar line does not change in that case, so hypr-dwm-land gained a separate event,
`hyprdwmland-reselect>><monitor>|v=…`, sent when a view op lands on the view already
shown; the player sounds that view on it (the all view arpeggiates). Verified on the
socket: two reselects of view 1,3,5 produced two reselect events and, by ear, two chords.

## Settings pane (2026-09-08)

The human, after a Jobs/Woz aside: the layout switch "should be a toggle in the instrument
pane, which I suppose is more of a plugin settings pane". So the plugin gained kind `panel`:
`Panel.qml` is a centred card on a scrim, modelled on the shell's own standalone panels
(the Wi-Fi QR and speed-test overlays, read from `/usr/share/omarchy/shell`), using the
shell's Ui components and style tokens; it watches the player's state files with FileView
so a change made from the CLI, the key or the menu ticks the right row, and applies
changes by running the player's own subcommands. Keyboard: Up/Down or J/K, Return, L, M,
Escape. Two things learned the hard way: the entry point had to live at the repository
root, because as `shell/Panel.qml` the shell's panel loader failed it with "File name case
mismatch" (Qt's check is compiled out on Linux per its source, so the cause is not
established); and the shell's hot reload left an already-loaded panel component stale, so
a restart was needed before new code showed. Tested by the AI with a screenshot of the pane
and a keyboard run through wtype (Down, Down, Return picked the cello; L flipped the
layout; Escape closed), state files checked before and after; the human asked whether the
skill covered this and it does not, the plugin-authoring knowledge came from the shell's
README and source. Mouse clicks were not exercised by the AI.

Mute state (2026-09-09): "the toggle in instruments to mute the plugin gets out of sync
with reality when you close and reopen the interface". The pane had kept mute as a local
flag and is rebuilt on every open. The player now writes `muted` (0/1) beside its pidfile on
start and on every toggle, and the pane watches that file like the instrument and layout.
Verified: the file follows `mute` from the CLI, and the pane's header reads MUTED after a
close and reopen while muted.

## Urgency versus focus_on_activate (2026-09-08)

The human put a terminal on a tag and stepped away to see if a bell would chime; the
window was revealed instead. Established by test: foot with `bell.urgent=yes` on a hidden
tag sends an activation request on BEL; Hyprland with `misc:focus_on_activate` on (the
Omarchy default) focuses it, hypr-dwm-land follows, and no urgent event reaches the socket.
Every earlier urgency demonstration had turned that option off for the duration. The
README now says so; the human asked for the note. Herdr's own "done" chime for an idle
agent is Herdr's sound, unrelated to compositor urgency.

## Corrected (2026-09-08)

Asked for "a swell and decay" on the saw, the AI sent MIDI sound controllers (CC 73 attack,
CC 72 release) and the human heard no change: "saw just seems like it's on or off". Measured
by rendering the same note to files at controller values 0 and 127: byte-identical
envelopes, for CC 71 and 74 too. fluidsynth's default modulators cover velocity, CC 7, 10,
11, 91, 93 and pitch bend; the sound controllers act only if the SoundFont defines
modulators for them, and FluidR3_GM does not. So every earlier use of them (the cello
strike's "reshaped envelope", the handbell's "release up") was inert, and what the human
approved in those rounds was the rest: velocity, channel level, the octave doubling, the
double hit, the reverb. The entries above are amended, not rewritten. Envelope changes now
go through SoundFont NRPNs (generator 34 attack, 38 release, as timecent offsets on the
preset's own values), verified the same way: a +12000 offset spread the saw's onset over
about a second and held its tail. The saw's onset and tail were then set by ear over three
rounds ("probably a little too far", "the arpeggio notes never hit full volume", "it feels
super legato now") to about 30 ms and 0.3 s: "sounds right to me now". A short note's swell
is scaled to its length so arpeggio notes reach full level.

## Removed

The pw-play fallback (sine tones rendered to files) was removed at the human's direction:
"a pw-play fallback bloats the repo for the sake of a worse product". A pre-rendered file
cannot react and needs an envelope baked in per note length; fluidsynth already does all of
that, so the program has one real backend and one dry one.

## Tested earlier the same day, dry backend only

The music logic was driven with scripted protocol lines and read back as the commands it
would send: a single tag plays its ratio with the right pitch bend (5/4 lands 14 cents under
the equal-tempered key, as it must); adding a tag plays the added note; viewing all
arpeggiates the occupied tags in order; leaving "all" plays the returned-to view as a chord;
an urgent tag plays 9/8 then 15/8 of its own ratio; viewing it plays the ratio once, as the
resolution, not twice. The dry backend was also run on the live Hyprland socket through two
real view changes. Not tested: any sound. fluidsynth and a SoundFont were not installed on
the development machine at the time (the human was away from the keyboard and could not
authorise the install), so the fluidsynth and pw-play backends are written against the
documented interfaces (fluidsynth's shell command table and man page) and unheard.

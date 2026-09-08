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

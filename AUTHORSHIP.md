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
instrument", so the strike channels keep the cello and reshape its envelope with MIDI sound
controllers (attack 0, longer release, brightness and resonance up) at full volume, doubled
an octave down, hit twice. Verdict: "hits like a train horn now, which I guess is the
natural conclusion to the direction I was pushing". Recorded as the intended sound.

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

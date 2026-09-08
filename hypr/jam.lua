-- Jam mode for just-hyprtonation: a Hyprland submap in which the tag keys play their notes
-- and move nothing. Enter with the key below; inside, 1..9, 0 and F1..F12 play the tag's
-- note, SHIFT + key its major triad, ESCAPE (or the entry key again) leaves. The submap
-- shadows every tag bind, so no window or view changes while it is on.
--
-- From ~/.config/hypr/bindings.lua (after the hypr-dwm-land keys):
--   dofile(os.getenv("HOME") .. "/just-hyprtonation/hypr/jam.lua")
-- Edit `key` for another chord.
local key = "SUPER + ALT + M"

local function note(n) return hl.dsp.event("hyprtonation>>note|" .. n) end
local function chord(n) return hl.dsp.event("hyprtonation>>chord|" .. n) end

hl.bind(key, hl.dsp.submap("jam"), { description = "Hyprtonation: jam mode" })
hl.define_submap("jam", function()
  for k = 1, 9 do
    hl.bind("code:" .. (k + 9), note(k))
    hl.bind("SHIFT + code:" .. (k + 9), chord(k))
  end
  hl.bind("code:19", note(8))            -- 0 sits an octave up
  hl.bind("SHIFT + code:19", chord(8))
  for k = 10, 21 do
    hl.bind("F" .. (k - 9), note(k))
    hl.bind("SHIFT + F" .. (k - 9), chord(k))
  end
  hl.bind("escape", hl.dsp.submap("reset"))
  hl.bind(key, hl.dsp.submap("reset"))
end)

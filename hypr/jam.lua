-- Jam mode for just-hyprtonation: a Hyprland submap in which the tag keys play their notes
-- and move nothing. Enter with the key below; inside, 1..9, 0 and F1..F12 play the tag's
-- note, SHIFT + key the triad on that scale degree, - and = move the key down or up a
-- semitone (with SHIFT, a tone), ESCAPE (or the entry key again) leaves. The submap
-- shadows every tag bind, so no window or view changes while it is on.
--
-- From ~/.config/hypr/bindings.lua (after the hypr-dwm-land keys):
--   dofile(os.getenv("HOME") .. "/just-hyprtonation/hypr/jam.lua")
-- Edit `key` for another chord.
local key = "SUPER + ALT + M"

local function ev(s) return hl.dsp.event("hyprtonation>>" .. s) end

hl.bind(key, hl.dsp.submap("jam"), { description = "Hyprtonation: jam mode" })
hl.define_submap("jam", function()
  for k = 1, 9 do
    hl.bind("code:" .. (k + 9), ev("note|" .. k))
    hl.bind("SHIFT + code:" .. (k + 9), ev("chord|" .. k))
  end
  hl.bind("code:19", ev("degree|10"))         -- 0 is the tenth white key
  hl.bind("SHIFT + code:19", ev("degreechord|10"))
  for k = 10, 21 do
    hl.bind("F" .. (k - 9), ev("note|" .. k))
    hl.bind("SHIFT + F" .. (k - 9), ev("chord|" .. k))
  end
  hl.bind("minus", ev("transpose|-1"))
  hl.bind("equal", ev("transpose|1"))
  hl.bind("SHIFT + minus", ev("transpose|-2"))
  hl.bind("SHIFT + equal", ev("transpose|2"))
  hl.bind("KP_Subtract", ev("transpose|-1"))
  hl.bind("KP_Add", ev("transpose|1"))
  hl.bind("escape", hl.dsp.submap("reset"))
  hl.bind(key, hl.dsp.submap("reset"))
end)

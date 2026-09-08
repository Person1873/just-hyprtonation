-- Jam mode for just-hyprtonation: a Hyprland submap in which the tag keys play their notes
-- and move nothing. Enter with the key below; inside, 1..9, 0 and F1..F12 play the tag's
-- note for as long as the key is down on a sustaining instrument (cello, organ, saw,
-- glass), SHIFT + key the triad on that scale degree, - and = move the key down or up a
-- semitone (with SHIFT, a tone), ESCAPE (or the entry key again) leaves. The submap
-- shadows every tag bind, so no window or view changes while it is on.
--
-- From ~/.config/hypr/bindings.lua (after the hypr-dwm-land keys):
--   dofile(os.getenv("HOME") .. "/.config/omarchy/plugins/person1873.just-hyprtonation/hypr/jam.lua")
-- Edit `key` for another chord.
local key = "SUPER + ALT + M"

local function ev(s) return hl.dsp.event("hyprtonation>>" .. s) end

hl.bind(key, hl.dsp.submap("jam"), { description = "Hyprtonation: jam mode" })
-- Key down starts the note, key up ends it. The release bind ignores modifiers so a key
-- let go after SHIFT still frees what it started (a release bind otherwise matches only
-- the exact modifiers held at the press).
local released = {}
local function keyed(mods, key, kind, n)
  local id = key:gsub("^code:", "k")
  hl.bind(mods .. key, ev("on|" .. id .. "|" .. kind .. "|" .. n))
  if not released[key] then
    released[key] = true
    hl.bind(key, ev("off|" .. id), { release = true, ignore_mods = true })
  end
end

local function leave()
  hl.dispatch(ev("alloff"))
  hl.dispatch(hl.dsp.submap("reset"))
end

hl.define_submap("jam", function()
  for k = 1, 9 do
    keyed("", "code:" .. (k + 9), "note", k)
    keyed("SHIFT + ", "code:" .. (k + 9), "chord", k)
  end
  keyed("", "code:19", "degree", 10)              -- 0 is the tenth white key
  keyed("SHIFT + ", "code:19", "degreechord", 10)
  for k = 10, 21 do
    keyed("", "F" .. (k - 9), "note", k)
    keyed("SHIFT + ", "F" .. (k - 9), "chord", k)
  end
  hl.bind("minus", ev("transpose|-1"))
  hl.bind("equal", ev("transpose|1"))
  hl.bind("SHIFT + minus", ev("transpose|-2"))
  hl.bind("SHIFT + equal", ev("transpose|2"))
  hl.bind("KP_Subtract", ev("transpose|-1"))
  hl.bind("KP_Add", ev("transpose|1"))
  hl.bind("escape", leave)
  hl.bind(key, leave)
end)

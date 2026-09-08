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
-- the exact modifiers held at the press). A release can still go missing (a keysym that
-- differs between press and release, for one), so a watchdog polls Hyprland for the key's
-- physical state while anything is held and sends the release itself.
local keycodes = { F1 = 67, F2 = 68, F3 = 69, F4 = 70, F5 = 71, F6 = 72, F7 = 73, F8 = 74,
                   F9 = 75, F10 = 76, F11 = 95, F12 = 96 }
local held = {}          -- keyid -> keycode while a key is down
local watchdog = nil

local function release(id)
  if not held[id] then return end
  held[id] = nil
  hl.dispatch(ev("off|" .. id))
  if next(held) == nil and watchdog then watchdog:set_enabled(false) end
end

local function watch()
  for id, code in pairs(held) do
    if not hl.is_key_down(code) then release(id) end
  end
end

local function press(id, code, kind, n)
  held[id] = code
  hl.dispatch(ev("on|" .. id .. "|" .. kind .. "|" .. n))
  if not watchdog then
    watchdog = hl.timer(watch, { timeout = 60, type = "repeat" })
  else
    watchdog:set_enabled(true)
  end
end

local released = {}
local function keyed(mods, key, kind, n)
  local id = key:gsub("^code:", "k")
  local code = tonumber(key:match("^code:(%d+)$")) or keycodes[key]
  hl.bind(mods .. key, function() press(id, code, kind, n) end)
  if not released[key] then
    released[key] = true
    hl.bind(key, function() release(id) end, { release = true, ignore_mods = true })
  end
end

local function leave()
  held = {}
  if watchdog then watchdog:set_enabled(false) end
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

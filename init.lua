-- TODO:
-- * swap windows: as an example, swap Emacs and Chrome positions which is especially useful if I am going to work on chrome for a long while (say, to do some research)


local hyper = {"shift", "cmd", "ctrl"}
local softhyper = {"cmd", "ctrl"}

-- These bindings are suitable for the LCD display
hs.hotkey.bind(hyper, "h", function()
     local win = hs.window.focusedWindow()
     local f = win:frame()
     local screen = win:screen()
     local max = screen:frame()

     f.x = max.x
     f.y = max.y
     f.w = max.w / 3
     f.h = max.h
     win:setFrame(f)
end)

hs.hotkey.bind(hyper, "l", function()
     local win = hs.window.focusedWindow()
     local f = win:frame()
     local screen = win:screen()
     local max = screen:frame()

     f.x = max.x + max.w / 3
     f.y = max.y
     f.w = max.w * 2 / 3
     f.h = max.h
     win:setFrame(f)
end)


-- Dimensions for my preferred window splits, in line with what is the most convenient for eye gaze.
-- Assuming a bigger monitor.
eyeline = 0.26
eyewidth = 0.38
centerRect = hs.geometry.rect(eyeline, 0.0, eyewidth, 1.0)
leftRect = hs.geometry.rect(0.0, 0.0, eyeline, 1.0)
rightRect = hs.geometry.rect(eyeline + eyewidth, 0.0, 1 - (eyeline + eyewidth), 0.9)
bottomRightRect = hs.geometry.rect(eyeline + eyewidth, 0.5, 1 - (eyeline + eyewidth), 0.5)
bottomCenterRect = hs.geometry.rect(eyeline, 0.5, eyewidth, 0.5)
topCenterRect = hs.geometry.rect(eyeline, 0.0, eyewidth, 0.5)

lcdCenterRect = hs.geometry.rect(0.1, 0.0, 0.8, 1.0)
lcdCenterRect2 = hs.geometry.rect(0.0, 0.1, 1.0, 0.8)

local asusScreen = "ASUS PB278"
local lcdScreen = "Color LCD"
local windowLayout = {
  {"Atom", nil, asusScreen, centerRect, nil, nil},
  {"iTerm", nil, asusScreen, bottomRightRect, nil, nil},
  {"Google Chrome", nil, asusScreen, rightRect, nil, nil},
  {"MacDown", nil, lcdScreen, lcdCenterRect, nil, nil},
  {"GitHub", nil, lcdScreen, lcdCenterRect2, nil, nil},
  {"Safari", nil, asusScreen, leftRect, nil, nil}
}
hs.hotkey.bind(hyper, "Y", function()
    hs.layout.apply(windowLayout)
end)

function arrangeApps(...)
  local arg={...}
  local hsLayout = {}
  for i, v in ipairs(arg) do
    name = v[1]
    rect = v[2]
    appWin = hs.appfinder.appFromName(name):mainWindow()
    appWin:moveToUnit(rect, 0)
    if i == 1 then
      appWin:focus()
    end
  end
end

function focusApp(appName)
  appWin = hs.appfinder.appFromName(appName):mainWindow()
  appWin:focus()
end

-- My programming layout
-- Hyper+J brings up Emacs in center view (Chrome to right).
-- Hyper+U brings up Chrome in center view (Emacs to right)
-- Hyper+K brings up iTerm in center view (Emacs bottom, Chrome right)
hs.hotkey.bind(
  softhyper, "J", function()
    arrangeApps(
      {"Atom", centerRect},
      {"Google Chrome", rightRect},
      {"iTerm", bottomRightRect})
end)
hs.hotkey.bind(
  softhyper, "U", function()
    arrangeApps(
      {"Google Chrome", centerRect},
      {"Atom", rightRect},
      {"iTerm", bottomRightRect})
end)
hs.hotkey.bind(softhyper, "K", function() focusApp("iTerm") end)
hs.hotkey.bind(
  hyper, "K", function()
    arrangeApps(
      {"iTerm", topCenterRect},
      {"Atom", bottomCenterRect},
      {"Google Chrome", rightRect})
end)
hs.hotkey.bind(
  softhyper, "H", function()
    arrangeApps({"MacDown", lcdCenterRect})
end)

-- Automatically reload config
function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", reload_config):start()
hs.alert.show("Config loaded")

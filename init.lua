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

-- FIXME: Chrome canary is not being recognized. 
local asusScreen = "ASUS PB278"
local windowLayout = {
  {"Emacs", nil, asusScreen, centerRect, nil, nil},
  {"iTerm", nil, asusScreen, bottomRightRect, nil, nil},
  {"Google Chrome Canary", nil, asusScreen, leftRect, nil, nil},
  {"Google Chrome", nil, asusScreen, rightRect, nil, nil}
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

-- Swap
hs.hotkey.bind(
  softhyper, "J", function()
    arrangeApps(
      {"Emacs", centerRect},
      {"Google Chrome", rightRect},
      {"iTerm", bottomRightRect})
end)
hs.hotkey.bind(
  softhyper, "U", function()
    arrangeApps(
      {"Google Chrome", centerRect},
      {"Emacs", rightRect},
      {"iTerm", bottomRightRect})
end)
hs.hotkey.bind(
  softhyper, "K", function()
    arrangeApps(
      {"iTerm", topCenterRect},
      {"Emacs", bottomCenterRect},
      {"Google Chrome", rightRect})
end)



function swapApp(app1, app2)
    local win1 = hs.appfinder.appFromName(app1):mainWindow()
    local win2 = hs.appfinder.appFromName(app2):mainWindow()
    local frame1 = win1:frame()
    local frame2 = win2:frame()

    win1:setFrame(frame2)
    win2:setFrame(frame1)
end

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
  hs.alert.show("Config loaded")
end)

hs.hints.style = "vimperator"
hs.hotkey.bind({"cmd"}, "K", function()
    hs.hints.windowHints()
end)


-- Automatically reload config
function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", reload_config):start()
hs.alert.show("Config loaded")

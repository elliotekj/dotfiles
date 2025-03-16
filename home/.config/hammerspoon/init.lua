local hyper = { "ctrl", "option", "shift", "cmd" }

hs.hotkey.bind(hyper, "j", function()
  hs.application.launchOrFocus("Arc")
end)

hs.hotkey.bind(hyper, "k", function()
  hs.application.launchOrFocus("Ghostty")
end)

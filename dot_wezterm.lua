local wezterm = require("wezterm")
local os = require("os")
local act = wezterm.action

local way = os.getenv("WAYLAND_DISPLAY")
local waybool = false
if way ~= "" then
  waybool = true
end

return {
  hide_tab_bar_if_only_one_tab = true,
  font = wezterm.font("JetBrainsMono NFM"),
  font_size = 14,
  front_end = "WebGpu",
  color_scheme = "Catppuccin Mocha",
  scrollback_lines = 40000,
  enable_wayland = waybool,
  check_for_updates = false,
  window_padding = {
    left = "0cell",
    right = "0cell",
    top = "0cell",
    bottom = "0cell",
  },
  keys = {
    {
      key = "H",
      mods = "CTRL",
      action = act.EmitEvent("scrollback-in-pager"),
    },
    {
      key = "s",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "w",
      mods = "ALT",
      action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    { key = "F9", mods = "ALT", action = wezterm.action.ShowTabNavigator },
  },
}

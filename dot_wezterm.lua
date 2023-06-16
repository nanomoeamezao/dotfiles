local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

local home = os.getenv("HOME")
local hostname = os.getenv("HOSTNAME")
local url_filter = "file://" .. hostname .. home .. "/"

function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

function drop_url_parts(dir)
	return string.gsub(dir, url_filter, "")
end

function filter_name(name, pane)
	if name == "nvim" then
		return pane.title
	end
	return name .. " " .. drop_url_parts(pane.current_working_dir)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local title = filter_name(basename(pane.foreground_process_name), pane)
	if tab.is_active then
		color = "blue"
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)

wezterm.on("scrollback-in-pager", function(window, pane)
	-- local dimentions = pane:get_dimentions()
	-- local text = pane:get_text_from_region(0, dimentions.scrollback_top, 0, dimentions.scrollback_top)
	local text = pane:get_lines_as_text(40000)

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewWindow({
			args = { "less", name },
		}),
		pane
	)

	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

return {
	hide_tab_bar_if_only_one_tab = true,
	font = wezterm.font("JetBrains Mono Nerd Font"),
	font_size = 14,
	front_end = "WebGpu",
	-- webgpu_preferred_adapter = {
	-- 	backend = "Vulkan",
	-- 	device = 35414,
	-- 	device_type = "IntegratedGpu",
	-- 	driver = "Intel open-source Mesa driver",
	-- 	driver_info = "Mesa 23.0.2",
	-- 	name = "Intel(R) UHD Graphics (ICL GT1)",
	-- 	vendor = 32902,
	-- },
	color_scheme = "Catppuccin Mocha",
	scrollback_lines = 40000,
	enable_wayland = false,
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

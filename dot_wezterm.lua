local wezterm = require("wezterm")
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

return {
	hide_tab_bar_if_only_one_tab = true,
	font = wezterm.font("JetBrains Mono Nerd Font"),
	font_size = 14,
	color_scheme = "Catppuccin Mocha",
	scrollback_lines = 40000,
	window_padding = {
		left = "0cell",
		right = "0cell",
		top = "0cell",
		bottom = "0cell",
	},
}

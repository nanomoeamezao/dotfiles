-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local lain = require("lain")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
local scripts = "~/scripts/"
awful.util.shell = "/bin/zsh"
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end
-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/cesious/theme.lua")
beautiful.notification_font = "NotoSansMono Nerd Font Regular 14"
beautiful.notification_max_width = 600
beautiful.notification_max_height = 200
beautiful.notification_icon_size = 50
beautiful.systray_icon_spacing = 3
-- hotkeys_popup
beautiful.hotkeys_font = "NotoSansMono Nerd Font Regular 12"
beautiful.hotkeys_description_font = "NotoSansMono Nerd Font Regular 12"
beautiful.hotkeys_modifiers_fg = "#cc0052"

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
browser = "google-chrome-stable"
filemanager = "pcmanfm"
editor = terminal .. "-e nvim"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.max,
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	--awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
	local instance = nil

	return function()
		if instance and instance.wibox.visible then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ theme = { width = 250 } })
		end
	end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"hotkeys",
		function()
			return false, hotkeys_popup.show_help
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", string.format("%s %s", editor, awesome.conffile) },
	{ "edit theme", string.format("%s %s", editor, ".config/awesome/themes/cesious/theme.lua") },
	{ "restart", awesome.restart },
}

myexitmenu = {
	{
		"log out",
		function()
			awesome.quit()
		end,
		"/usr/share/icons/Arc-Maia/actions/24@2x/system-log-out.png",
	},
	{ "suspend", "systemctl suspend", "/usr/share/icons/Arc-Maia/actions/24@2x/gnome-session-suspend.png" },
	{ "hibernate", "systemctl hibernate", "/usr/share/icons/Arc-Maia/actions/24@2x/gnome-session-hibernate.png" },
	{ "reboot", "systemctl reboot", "/usr/share/icons/Arc-Maia/actions/24@2x/view-refresh.png" },
	{ "shutdown", "poweroff", "/usr/share/icons/Arc-Maia/actions/24@2x/system-shutdown.png" },
}

mymainmenu = freedesktop.menu.build({
	before = {
		{ "Terminal", terminal, "/usr/share/icons/Moka/32x32/apps/utilities-terminal.png" },
		{ "Browser", browser, "/usr/share/icons/hicolor/24x24/apps/chromium.png" },
		{ "Files", filemanager, "/usr/share/icons/Arc-Maia/places/32/user-home.png" },
		-- other triads can be put here
	},
	after = {
		{ "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome16.png" },
		{ "Exit", myexitmenu, "/usr/share/icons/Arc-Maia/actions/24@2x/system-restart.png" },
		-- other triads can be put here
	},
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M ")

local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local mycal = calendar_widget({
	radius = 8,
	placement = "top_right",
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		mycal.toggle()
	end
end)
markup = lain.util.markup
darkblue = theme.bg_focus
blue = "#9EBABA"
red = "#EB8F8F"
seperator = wibox.widget.textbox(' <span color="' .. blue .. '">| </span>')
spacer = wibox.widget.textbox(' <span color="' .. blue .. '"> </span>')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local hostname = os.getenv("HOSTNAME")
awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

	beautiful.useless_gap = 4
	-- Create a tasklist widget
	s.mytasklist = require("tasklist")(s)

	-- vol widget
	local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

	local tray = wibox.widget.systray({ visible = true, forced_width = 200 })
	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	local right_widgets = wibox.layout.fixed.horizontal()
	right_widgets:add(tray)
	right_widgets:add(volume_widget({
		main_color = "#af13f7",
		mute_color = "#ff0000",
		thickness = 5,
		size = 25,
		widget_type = "arc",
	}))
	right_widgets:add(seperator)
	if hostname == "neotop" then
		local battery_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
		right_widgets:add(battery_widget({
			size = 22,
			show_current_level = true,
		}))
		right_widgets:add(seperator)
	end
	right_widgets:add(mykeyboardlayout)
	right_widgets:add(seperator)
	right_widgets:add(mytextclock)
	right_widgets:add(seperator)
	right_widgets:add(s.mylayoutbox)

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			s.mypromptbox,
		},
		{
			left = 200,
			layout = wibox.container.margin,
			s.mytasklist, -- Middle widget
		},
		right_widgets,
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 1, function()
		mymainmenu:hide()
	end),
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end)
	-- awful.button({}, 4, awful.tag.viewnext),
	-- awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	-- awful.key({ modkey }, "w", function()
	-- 	mymainmenu:show()
	-- end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "b", function()
		awful.spawn("/usr/bin/rofi-rbw")
	end, { description = "open rofi-rbw", group = "launcher" }),
	awful.key({ modkey }, "w", function()
		awful.spawn("/usr/bin/rofi -show window -filter nvim")
	end, { description = "open rofi nvim window switcher", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "w", function()
		awful.spawn("/usr/bin/rofi -show window")
	end, { description = "open rofi window switcher", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "b", function()
		awful.spawn(browser)
	end, { description = "launch Browser", group = "launcher" }),
	awful.key({ modkey }, "r", function()
		awful.spawn.with_shell("/usr/bin/rofi -show drun -modi drun")
	end, { description = "launch rofi", group = "launcher" }),
	awful.key({ modkey }, "e", function()
		awful.spawn("pcmanfm")
	end, { description = "launch thunar", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "e", function()
		awful.spawn.with_shell(terminal .. " -e nnn")
	end, { description = "launch nnn", group = "launcher" }),
	awful.key({ modkey }, "v", function()
		awful.spawn.with_shell("~/scripts/rofi-vpn")
	end, { description = "rofi vpn", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),
	-- awful.key({}, "Print", function()
	-- awful.spawn("/usr/bin/i3-scrot -d")
	-- end, { description = "capture a screenshot", group = "screenshot" }),
	awful.key({ "Shift" }, "Print", function()
		awful.spawn("/usr/bin/flameshot gui")
	end, { description = "capture a screenshot of selection", group = "screenshot" }),

	awful.key({ modkey }, "p", function()
		awful.spawn.easy_async_with_shell("mpv_url", function(out) end)
	end, { description = "run url from clip in mpv", group = "media" }),

	awful.key({ "Control", "Mod1" }, "l", function()
		awful.spawn.easy_async_with_shell("dm-tool lock", function() end)
	end, { description = "lock session", group = "session" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			client.focus = c
			c:raise()
		end
	end, { description = "restore minimized", group = "client" })
)

clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "x", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("/usr/bin/brightnessctl set 10%-")
	end, { description = "Brightness down", group = "brightness" }),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("/usr/bin/brightnessctl set 10%+")
	end, { description = "Brightness up", group = "brightness" }),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn("/usr/bin/amixer -D pulse set Master toggle")
	end, { description = "Mute volume", group = "sound" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("/usr/bin/amixer -D pulse sset Master 5%+")
	end, { description = "vol +", group = "sound" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("/usr/bin/amixer -D pulse sset Master 5%-")
	end, { description = "vol -", group = "sound" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		client.focus = c
		c:raise()
		mymainmenu:hide()
	end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			callback = awful.client.setslave,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
			},
			class = {
				"Arandr",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Wpa_gui",
				"pinentry",
				"veromix",
				"xtightvncviewer",
			},

			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	{ rule = { class = "Firefox" }, properties = { screen = 1, tag = "2" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.stickybutton(c),
			-- awful.titlebar.widget.ontopbutton    (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
	-- Hide the menubar if we are not floating
	-- local l = awful.layout.get(c.screen)
	-- if not (l.name == "floating" or c.floating) then
	--     awful.titlebar.hide(c)
	-- end
end)

--{{Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
		client.focus = c
	end
end)
--}}
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
	screen[s]:connect_signal("arrange", function()
		local clients = awful.client.visible(s)
		local layout = awful.layout.getname(awful.layout.get(s))

		for _, c in pairs(clients) do
			-- No borders with only one humanly visible client
			if c.maximized then
				-- NOTE: also handled in focus, but that does not cover maximizing from a
				-- tiled state (when the client had focus).
				c.border_width = 0
			elseif c.floating or layout == "floating" then
				c.border_width = beautiful.border_width
			elseif layout == "max" or layout == "fullscreen" then
				c.border_width = 0
			else
				local tiled = awful.client.tiled(c.screen)
				if #tiled == 1 then -- and c == tiled[1] then
					tiled[1].border_width = 0
					-- if layout ~= "max" and layout ~= "fullscreen" then
					-- XXX: SLOW!
					-- awful.client.moveresize(0, 0, 2, 0, tiled[1])
					-- end
				else
					c.border_width = beautiful.border_width
				end
			end
		end
	end)
end

-- }}}

--client.connect_signal("property::floating", function (c)
--    if c.floating then
--        awful.titlebar.show(c)
--    else
--        awful.titlebar.hide(c)
--    end
--end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

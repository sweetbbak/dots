-- ## Keybindings ##
-- ~~~~~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- vars
-- ~~~~~~~~~

-- modkey
local modkey = "Mod4"
-- modifer keys
local shift = "Shift"
local ctrl = "Control"
local alt = "Mod1"

-- Default Applications :
--terminal = "alacritty"
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Configurations
-- ~~~~~~~~~~~~~~

-- # Mouse bindings :
awful.mouse.append_global_mousebindings({
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

-- Sloppy focus :
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

-- # Key bindings :
-- General Awesome keys
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	awful.key({ modkey, ctrl }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	awful.key({ modkey, shift }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ modkey, shift }, "Return", function()
		awful.spawn("xterm")
	end, { description = "open a terminal", group = "launcher" }),
	-- awful.key({ modkey }, "p", function() menubar.show() end,
	--	{description = "show the menubar", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),

	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),

	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	awful.key({ modkey, ctrl }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),

	awful.key({ modkey, ctrl }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	awful.key({ modkey, ctrl }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:activate({ raise = true, context = "key.unminimize" })
		end
	end, { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, shift }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),

	awful.key({ modkey, shift }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),

	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),

	awful.key({ modkey, shift }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),

	awful.key({ modkey, shift }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),

	awful.key({ modkey, ctrl }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),

	awful.key({ modkey, ctrl }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),

	awful.key({ modkey, shift }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, ctrl },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, shift },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, ctrl, shift },
		keygroup = "numrow",
		description = "toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { modkey },
		keygroup = "numpad",
		description = "select layout directly",
		group = "layout",
		on_press = function(index)
			local t = awful.screen.focused().selected_tag
			if t then
				t.layout = t.layouts[index] or t.layout
			end
		end,
	}),
})

-- Media Control :
awful.keyboard.append_global_keybindings({
	-- Volume Keys :
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("amixer -q -D pulse sset Master 5%-", false)
	end),

	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("amixer -q -D pulse sset Master 5%+", false)
	end),

	awful.key({}, "XF86AudioMute", function()
		awful.spawn("amixer -D pulse set Master 1+ toggle", false)
	end),

	-- Media Keys :
	awful.key({}, "XF86AudioPlay", function()
		awful.spawn("playerctl play-pause", false)
	end),

	awful.key({}, "XF86AudioNext", function()
		awful.spawn("playerctl next", false)
	end),

	awful.key({}, "XF86AudioPrev", function()
		awful.spawn("playerctl previous", false)
	end),

	-- Brightness Keys :
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("brightnessctl set 5%+", false)
	end),

	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("brightnessctl set 5%-", false)
	end),
})

-- Standard program :
awful.keyboard.append_global_keybindings({
	-- File Manager :
	awful.key({ ctrl, shift }, "f", function()
		awful.spawn(string.format("pcmanfm"))
	end, { description = "pcmanfm", group = "file manager" }),

	-- Screenshots Keys :
	awful.key({}, "Print", function()
		awful.spawn("screenshot")
	end, { description = "Maim", group = "screenshot" }),
	awful.key({ modkey }, "Print", function()
		awful.spawn("screenshot-select")
	end, { description = "Maim", group = "screenshot" }),

	-- Rofi :
	awful.key({ modkey }, "p", function()
		awful.spawn("rofi -show drun -show-icons &>> /tmp/rofi.log")
	end, { description = "rofi launcher", group = "launcher" }),

	-- Main Menu :
	-- awful.key({ modkey }, "r", function () awful.spawn("rofi -show drun -show-icons -theme ~/.config/awesome/libs/misc/rofi/config.rasi &>> /tmp/rofi.log") end, {description = "rofi launcher", group = "launcher"}),

	-- ClipMenu :
	awful.key({ modkey }, "Insert", function()
		awful.spawn("clipmenu")
	end, { description = "clipboard history by rofi/clipmenud", group = "awesome" }),

	-- Firefox :
	awful.key({ modkey }, "b", function()
		awful.spawn("firefox")
	end, { description = "Firefox", group = "Web Browser" }),

	-- Center Window :
	awful.key({ modkey }, "y", awful.placement.centered),
})

-- Systray :
--awful.keyboard.append_global_keybindings({
--	awful.key({ modkey }, "=", function () awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end, {description = "Toggle systray visibility", group = "custom"})
--})

-- Bar :
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "=", function()
		for s in screen do
			s.mywibar.visible = not s.mywibar.visible
		end
	end, { description = "toggle wibox", group = "awesome" }),
})

awful.keyboard.append_global_keybindings({
	awful.key({ alt }, "Tab", function()
		awesome.emit_signal("sidebar::toggle")
	end), -- Sidebar
	awful.key({ alt }, "t", function()
		awful.titlebar.toggle(client.focus)
	end),
})

-- Client :
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),

		awful.key({ modkey, "Shift" }, "c", function(c)
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
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		awful.key({ modkey }, "n", function(c)
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
	})
end)

--________________________________________________________________


-- -- {{{ Mouse bindings
-- root.buttons(gears.table.join(
-- 	awful.button({}, 3, function()
-- 		mymainmenu:toggle()
-- 	end),
-- 	awful.button({}, 4, awful.tag.viewnext),
-- 	awful.button({}, 5, awful.tag.viewprev)
-- ))
-- -- }}}

-- awful.keyboard.append_global_keybindings({
-- 	awful.key({ modkey }, "Down", function()
-- 		awful.placement.centered(client.focus, {
-- 			honor_workarea = true,
-- 		})
-- 	end, { description = "Center a floating window", group = "client" }),
-- })

-- -- {{{ Key bindings
-- globalkeys = gears.table.join(
-- 	--	awful.key({ modkey, }, "s", hotkeys_popup.show_help,
-- 	--		{ description = "show help", group = "awesome" }),
-- 	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
-- 	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
-- 	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

-- 	awful.key({ modkey }, "j", function()
-- 		awful.client.focus.byidx(1)
-- 	end, { description = "focus next by index", group = "client" }),
-- 	awful.key({ modkey }, "k", function()
-- 		awful.client.focus.byidx(-1)
-- 	end, { description = "focus previous by index", group = "client" }),
-- 	awful.key({ modkey }, "w", function()
-- 		mymainmenu:show()
-- 	end, { description = "show main menu", group = "awesome" }),

-- 	-- Layout manipulation
-- 	awful.key({ modkey, "Shift" }, "j", function()
-- 		awful.client.swap.byidx(1)
-- 	end, { description = "swap with next client by index", group = "client" }),
-- 	awful.key({ modkey, "Shift" }, "k", function()
-- 		awful.client.swap.byidx(-1)
-- 	end, { description = "swap with previous client by index", group = "client" }),
-- 	awful.key({ modkey, "Control" }, "j", function()
-- 		awful.screen.focus_relative(1)
-- 	end, { description = "focus the next screen", group = "screen" }),
-- 	awful.key({ modkey, "Control" }, "k", function()
-- 		awful.screen.focus_relative(-1)
-- 	end, { description = "focus the previous screen", group = "screen" }),
-- 	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
-- 	awful.key({ modkey }, "Tab", function()
-- 		awful.client.focus.history.previous()
-- 		if client.focus then
-- 			client.focus:raise()
-- 		end
-- 	end, { description = "go back", group = "client" }),

-- 	-- Standard program
-- 	awful.key({ modkey }, "Return", function()
-- 		awful.spawn(terminal)
-- 	end, { description = "open a terminal", group = "launcher" }),
-- 	awful.key({ modkey }, "b", function()
-- 		awful.spawn("firefox")
-- 	end, { description = "open qutebrowser", group = "launcher" }),
-- 	awful.key({ modkey }, "s", function()
-- 		awful.spawn("flameshot gui")
-- 		naughty.notify({
-- 			title = " ",
-- 			fg = "#8293ce",
-- 			text = "      Screenshot taken",
-- 			font = "Roboto Mono Nerd Font 12",
-- 			margin = 15,
-- 			opacity = 0.7,
-- 			--border_width = 3,
-- 			--border_color = "#9888c6",
-- 			--replaces_id = 1,
-- 			--border_width = 3,
-- 			--border_color = "#89b4fa",
-- 			width = 300,
-- 			height = 100,
-- 			shape = function(cr, width, heigt)
-- 				gears.shape.rounded_rect(cr, width, heigt, 15)
-- 			end,
-- 		})
-- 	end, { description = "Take screenshot fullscreen", group = "screen" }),
-- 	awful.key({ modkey, "Shift" }, "s", function()
-- 		awful.spawn("scrot -s -q 100 /home/sweet/Pictures/screenshots/%Y-%m-%d_$wx$h.png")
-- 	end, { description = "Take screenshot selection", group = "screen" }),
-- 	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
-- 	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

-- 	awful.key({ modkey }, "h", function()
-- 		awful.tag.incmwfact(0.05)
-- 	end, { description = "increase master width factor", group = "layout" }),
-- 	awful.key({ modkey }, "l", function()
-- 		awful.tag.incmwfact(-0.05)
-- 	end, { description = "decrease master width factor", group = "layout" }),
-- 	awful.key({ modkey, "Shift" }, "h", function()
-- 		awful.tag.incnmaster(1, nil, true)
-- 	end, { description = "increase the number of master clients", group = "layout" }),
-- 	awful.key({ modkey, "Shift" }, "l", function()
-- 		awful.tag.incnmaster(-1, nil, true)
-- 	end, { description = "decrease the number of master clients", group = "layout" }),
-- 	awful.key({ modkey, "Control" }, "h", function()
-- 		awful.tag.incncol(1, nil, true)
-- 	end, { description = "increase the number of columns", group = "layout" }),
-- 	awful.key({ modkey, "Control" }, "l", function()
-- 		awful.tag.incncol(-1, nil, true)
-- 	end, { description = "decrease the number of columns", group = "layout" }),
-- 	awful.key({ modkey }, "m", function()
-- 		awful.layout.inc(1)
-- 	end, { description = "select next", group = "layout" }),
-- 	awful.key({ modkey, "Shift" }, "m", function()
-- 		awful.layout.inc(-1)
-- 	end, { description = "select previous", group = "layout" }),

-- 	awful.key({ modkey, "Control" }, "n", function()
-- 		local c = awful.client.restore()
-- 		-- Focus restored client
-- 		if c then
-- 			c:emit_signal("request::activate", "key.unminimize", { raise = true })
-- 		end
-- 	end, { description = "restore minimized", group = "client" }),

-- 	-- Prompt
-- 	awful.key({ modkey, "Shift" }, "r", function()
-- 		awful.screen.focused().mypromptbox:run()
-- 	end, { description = "run prompt", group = "launcher" }),

-- 	awful.key({ modkey }, "x", function()
-- 		awful.prompt.run({
-- 			prompt = "Run Lua code: ",
-- 			textbox = awful.screen.focused().mypromptbox.widget,
-- 			exe_callback = awful.util.eval,
-- 			history_path = awful.util.get_cache_dir() .. "/history_eval",
-- 		})
-- 	end, { description = "lua execute prompt", group = "awesome" }),
-- 	-- Scratchpad
-- 	awful.key({ modkey }, "p", function()
-- 		term_scratch:toggle()
-- 	end, { description = "show the scratchpad", group = "launcher" }),

-- 	-- ani-cli
-- 	awful.key({ modkey }, "a", function()
-- 		term_anicli:toggle()
-- 	end, { description = "show the scratchpad", group = "launcher" }),

-- 	-- Thunar
-- 	awful.key({ modkey }, "e", function()
-- 		awful.spawn("thunar")
-- 	end, { description = "show Dmenu", group = "launcher" }),

-- 	-- Rofi
-- 	awful.key({ modkey }, "space", function()
-- 		awful.spawn("/home/sweet/bin/launcher.sh")
-- 	end, { description = "show rofi", group = "launcher" }),

-- 	-- Window switcher
-- 	awful.key({ modkey }, "Tab", function()
-- 		awesome.emit_signal("bling::window_switcher::turn_on")
-- 	end, { description = "window switcher", group = "bling" }),

-- 	-- Rofi Calc
-- 	awful.key({ modkey, "Shift" }, "c", function()
-- 		awful.spawn("kpl")
-- 	end, { description = "show rofi", group = "launcher" }),

-- 	-- Brightness up
-- 	awful.key({}, "XF86MonBrightnessUp", function()
-- 		--local brightness = [[/home/sv/scripts/brightness-bar.sh]]
-- 		awful.spawn("/home/sweet/scripts/Scripts-AwesomeWM/brightness-up.sh")
-- 		br_signal:emit_signal("timeout")
-- 		--awful.spawn.easy_async(brightness, function(stdout)
-- 		--	naughty.notify {
-- 		--		--title = "Brightness",
-- 		--		text = "  " .. stdout,
-- 		--		font = "Roboto Mono Nerd Font 12",
-- 		--		replaces_id = 1,
-- 		--		--border_width = 3,
-- 		--		--border_color = "#89b4fa",
-- 		--		width = 170,
-- 		--		height = 25,
-- 		--		shape = function(cr, width, heigt)
-- 		--			gears.shape.rounded_rect(cr, width, heigt, 5)
-- 		--		end
-- 		--	}
-- 		--end)
-- 	end, { description = "Brightness up", group = "system" }),

-- 	-- Brightness down
-- 	awful.key({}, "XF86MonBrightnessDown", function()
-- 		--local brightness = [[/home/sv/scripts/brightness-bar.sh]]
-- 		awful.spawn("/home/sweet/scripts/Scripts-AwesomeWM/brightness-down.sh")
-- 		br_signal:emit_signal("timeout")
-- 		--awful.spawn.easy_async(brightness, function(stdout)
-- 		--	naughty.notify {
-- 		--		--title = "Brightness",
-- 		--		text = "  " .. stdout,
-- 		--		font = "Roboto Mono Nerd Font 12",
-- 		--		replaces_id = 1,
-- 		--		--border_width = 3,
-- 		--		--border_color = "#89b4fa",
-- 		--		width = 170,
-- 		--		height = 25,
-- 		--		shape = function(cr, width, heigt)
-- 		--			gears.shape.rounded_rect(cr, width, heigt, 5)
-- 		--		end
-- 		--	}
-- 		--end)
-- 	end, { description = "Brightness down", group = "system" }),

-- 	-- Volume up
-- 	awful.key({}, "XF86AudioRaiseVolume", function()
-- 		--local volume = [[/home/sv/scripts/volume-bar.sh]]
-- 		awful.spawn("/home/sweet/.config/openbox/scripts/volume-control up")
-- 		vo_signal:emit_signal("timeout")
-- 		--awful.spawn.easy_async(volume, function(stdout)
-- 		--	naughty.notify {
-- 		--		--title = "Brightness",
-- 		--		text = "   " .. stdout,
-- 		--		font = "Roboto Mono Nerd Font 12",
-- 		--		replaces_id = 1,
-- 		--		--border_width = 3,
-- 		--		--border_color = "#89b4fa",
-- 		--		width = 170,
-- 		--		height = 25,
-- 		--		shape = function(cr, width, heigt)
-- 		--			gears.shape.rounded_rect(cr, width, heigt, 5)
-- 		--		end
-- 		--	}
-- 		--end)
-- 	end, { description = "Volume up", group = "system" }),

-- 	-- Volume down
-- 	awful.key({}, "XF86AudioLowerVolume", function()
-- 		--local volume = [[/home/sv/scripts/volume-bar.sh]]
-- 		awful.spawn("/home/sweet/.config/openbox/scripts/volume-control down")
-- 		vo_signal:emit_signal("timeout")
-- 		--awful.spawn.easy_async(volume, function(stdout)
-- 		--	naughty.notify {
-- 		--		--title = "Brightness",
-- 		--		text = "   " .. stdout,
-- 		--		font = "Roboto Mono Nerd Font 12",
-- 		--		replaces_id = 1,
-- 		--		--border_width = 3,
-- 		--		--border_color = "#89b4fa",
-- 		--		width = 170,
-- 		--		height = 25,
-- 		--		shape = function(cr, width, heigt)
-- 		--			gears.shape.rounded_rect(cr, width, heigt, 5)
-- 		--		end
-- 		--	}
-- 		--end)
-- 	end, { description = "Volume down", group = "system" })
-- )

-- clientkeys = gears.table.join(
-- 	awful.key({ modkey }, "f", function(c)
-- 		c.fullscreen = not c.fullscreen
-- 		c:raise()
-- 	end, { description = "toggle fullscreen", group = "client" }),
-- 	awful.key({ modkey }, "c", function(c)
-- 		c:kill()
-- 	end, { description = "close", group = "client" }),
-- 	awful.key(
-- 		{ modkey, "Control" },
-- 		"space",
-- 		awful.client.floating.toggle,
-- 		{ description = "toggle floating", group = "client" }
-- 	),
-- 	awful.key({ modkey, "Control" }, "Return", function(c)
-- 		c:swap(awful.client.getmaster())
-- 	end, { description = "move to master", group = "client" }),
-- 	awful.key({ modkey }, "o", function(c)
-- 		c:move_to_screen()
-- 	end, { description = "move to screen", group = "client" }),
-- 	awful.key({ modkey }, "t", function(c)
-- 		c.ontop = not c.ontop
-- 	end, { description = "toggle keep on top", group = "client" }),
-- 	awful.key({ modkey }, "n", function(c)
-- 		-- The client currently has the input focus, so it cannot be
-- 		-- minimized, since minimized clients can't have the focus.
-- 		c.minimized = true
-- 	end, { description = "minimize", group = "client" })
-- 	--awful.key({ modkey, }, "m",
-- 	--	function(c)
-- 	--		c.maximized = not c.maximized
-- 	--		c:raise()
-- 	--	end,
-- 	--	{ description = "(un)maximize", group = "client" }),
-- 	--awful.key({ modkey, }, "m",
-- 	--	{ description = "Toggle modes", group = "client" }),
-- 	--awful.key({ modkey, "Control" }, "m",
-- 	--	function(c)
-- 	--		c.maximized_vertical = not c.maximized_vertical
-- 	--		c:raise()
-- 	--	end,
-- 	--	{ description = "(un)maximize vertically", group = "client" }),
-- 	--awful.key({ modkey, "Shift" }, "m",
-- 	--	function(c)
-- 	--		c.maximized_horizontal = not c.maximized_horizontal
-- 	--		c:raise()
-- 	--	end,
-- 	--	{ description = "(un)maximize horizontally", group = "client" })
-- )

-- -- Bind all key numbers to tags.
-- -- Be careful: we use keycodes to make it work on any keyboard layout.
-- -- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 9 do
-- 	globalkeys = gears.table.join(
-- 		globalkeys,
-- 		-- View tag only.
-- 		awful.key({ modkey }, "#" .. i + 9, function()
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[i]
-- 			if tag then
-- 				tag:view_only()
-- 			end
-- 		end, { description = "view tag #" .. i, group = "tag" }),
-- 		-- Toggle tag display.
-- 		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[i]
-- 			if tag then
-- 				awful.tag.viewtoggle(tag)
-- 			end
-- 		end, { description = "toggle tag #" .. i, group = "tag" }),
-- 		-- Move client to tag.
-- 		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
-- 			if client.focus then
-- 				local tag = client.focus.screen.tags[i]
-- 				if tag then
-- 					client.focus:move_to_tag(tag)
-- 				end
-- 			end
-- 		end, { description = "move focused client to tag #" .. i, group = "tag" }),
-- 		-- Toggle tag on focused client.
-- 		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
-- 			if client.focus then
-- 				local tag = client.focus.screen.tags[i]
-- 				if tag then
-- 					client.focus:toggle_tag(tag)
-- 				end
-- 			end
-- 		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
-- 	)
-- end

-- clientbuttons = gears.table.join(
-- 	awful.button({}, 1, function(c)
-- 		c:emit_signal("request::activate", "mouse_click", { raise = true })
-- 	end),
-- 	awful.button({ modkey }, 1, function(c)
-- 		c:emit_signal("request::activate", "mouse_click", { raise = true })
-- 		awful.mouse.client.move(c)
-- 	end),
-- 	awful.button({ modkey }, 3, function(c)
-- 		c:emit_signal("request::activate", "mouse_click", { raise = true })
-- 		awful.mouse.client.resize(c)
-- 	end)
-- )

-- -- Set keys
-- root.keys(globalkeys)


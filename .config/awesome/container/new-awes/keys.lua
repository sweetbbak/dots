local gears = require('gears')
local awful = require('awful')
local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')
local musicctl = require('lib.musicctl')
local drop = require('ui.drop')

local modkey = 'Mod4'

local keys = {}

-- {{{ Keyboard bindings
keys.globalkeys = gears.table.join(

	-- {{{ Misc
	awful.key({ modkey }, 'comma', hotkeys_popup.show_help, { description = 'show help', group = 'awesome' }),
	awful.key({ modkey }, 'Left', awful.tag.viewprev, { description = 'view previous', group = 'tag' }),
	awful.key({ modkey }, 'Right', awful.tag.viewnext, { description = 'view next', group = 'tag' }),
	awful.key({ modkey }, 'Escape', awful.tag.history.restore, { description = 'go back', group = 'tag' }),

	-- awful.key({ modkey }, 'v', function() drop.toggle() end, { description = 'test', group = 'tag' }),
	-- awful.key({ modkey }, 'b', function() _G.screen.primary.notif_panel:toggle() end, { description = 'test', group = 'tag' }),
	-- awful.key({ modkey }, 'F1', function()
	-- 	awful.spawn.with_shell("zathura " .. os.getenv("HOME") .. "/.local/share/doc/manual.pdf")
	-- end,
  -- { description = 'Open manual', group = 'docs' }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

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
	awful.key({ modkey }, "b", function()
		awful.spawn("firefox")
	end, { description = "open qutebrowser", group = "launcher" }),
	awful.key({ modkey }, "s", function()
		awful.spawn("scrot -q 100 /home/sweet/Pictures/screenshots/%Y-%m-%d_$wx$h.png")
		naughty.notify({
			title = " ",
			fg = "#8293ce",
			text = "      Screenshot taken",
			font = "Roboto Mono Nerd Font 12",
			margin = 15,
			opacity = 0.7,
			--border_width = 3,
			--border_color = "#9888c6",
			--replaces_id = 1,
			--border_width = 3,
			--border_color = "#89b4fa",
			width = 300,
			height = 100,
			shape = function(cr, width, heigt)
				gears.shape.rounded_rect(cr, width, heigt, 15)
			end,
		})
	end, { description = "Take screenshot fullscreen", group = "screen" }),
	awful.key({ modkey, "Shift" }, "s", function()
		awful.spawn("scrot -s -q 100 /home/sweet/Pictures/screenshots/%Y-%m-%d_$wx$h.png")
	end, { description = "Take screenshot selection", group = "screen" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "l", function()
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
	awful.key({ modkey }, "m", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "m", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey, "Shift" }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
  
	-- Menubar
	awful.key({ modkey }, "p", function() term_scratch:toggle() end,
	{ description = "show the scratchpad", group = "launcher" }),



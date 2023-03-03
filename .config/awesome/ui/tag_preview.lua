local bling = require("bling")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

bling.widget.tag_preview.enable({
	show_client_content = false,
	scale = 0.25,
	-- honor_padding = false,
	-- honor_workarea = false,
  parent = awful.screen.focused,
	x = 300,
	y = 300,
	placement_fn = function(c)
		awful.placement.screen.focused(c, {
      parent = awful.screen.focused,
			margins = {
				-- bottom = beautiful.bar_height + beautiful.useless_gap * 2,
				-- bottom = 750,
				-- left = beautiful.useless_gap * 318.5,
				-- left = 1919.4,
        parent = awful.screen.focused,
				top = 300,
				right = 300,
			},
		})
	end,
	background_widget = wibox.widget({
		image = beautiful.wallpaper,
		horizontal_fit_policy = "fit",
		vertical_fit_policy = "fit",
		widget = wibox.widget.imagebox,
	}),
})

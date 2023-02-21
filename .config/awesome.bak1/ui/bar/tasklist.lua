-- ## Tasklist ##
-- ~~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

return function(s)

    -- Tasklist buttons
    local tasklist_buttons = gears.table.join(
		awful.button({ }, 1, function (c) c:activate { context = "tasklist", action = "toggle_minimization" } end),
		awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
		awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
		awful.button({ }, 5, function() awful.client.focus.byidx( 1) end)
    )

	-- Create a tasklist widget
    local tasklist = awful.widget.tasklist 
	{
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
		style = {
			font 		= theme.font,
			bg_normal 	= colors.container,
			bg_focus 	= colors.container,
			bg_minimize = colors.black ,
			shape 		= helpers.rrect(dpi(4)),
		},
		layout = {
			spacing = dpi(8),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							awful.widget.clienticon,
							forced_height 	= dpi(15),
							forced_width 	= dpi(15),
							halign = "center",
							valign = "center",
							widget = wibox.container.place,
						},
						margins = dpi(2),
						widget = wibox.container.margin,
					},
					{
						nil,
						nil,
						{
							nil,
							{
								widget = wibox.container.background,
								id = "pointer",
								bg = colors.main_scheme,
								shape = gears.shape.rounded_bar,
								forced_height = dpi(2),
								forced_width = dpi(20)
							},
							expand = "none",
							layout = wibox.layout.align.horizontal
						},
						layout = wibox.layout.align.vertical
					},
					layout = wibox.layout.stack,
				},
				forced_width = dpi(40),
				id = "background_role",
				widget = wibox.container.background,
			},
			top = dpi(4),
			bottom = dpi(4),
			left = dpi(2),
			right = dpi(2),
			widget  = wibox.container.margin
		}
	}
	return tasklist
end

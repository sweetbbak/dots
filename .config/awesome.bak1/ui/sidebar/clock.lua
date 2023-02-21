-- ## Clock ##
-- ~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require ("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Day
local day = wibox.widget.textbox()
day.font = "Roboto bold 8"
day.align = 'center'

local date = wibox.widget.textbox()
date.font = "Roboto bold 10"
date.align = 'center'

gears.timer {
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		day.markup = "<span foreground='"..colors.red.."'>"..os.date("%A").."</span>"
		date.markup = os.date("%d %B %Y")
	end
}

return wibox.widget {
	day,
	date,
	spacing = dpi(4),
	layout = wibox.layout.fixed.vertical,
}

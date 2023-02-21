-- ## Sidebar button ##
-- ~~~~~~~~~~~~~~~~~~~~


-- Requirements :
-- ~~~~~~~~~~~~~~
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local sidebar = require("ui.sidebar")


local sidebar_icon = wibox.widget{
	markup = "",
	font = theme.taglist_font,
	valign = "center",
	align = "center",
	widget = wibox.widget.textbox
}

sidebar_icon:buttons{gears.table.join(
	awful.button({ }, 1, function ()
		sidebar.toggle(s)
	end)
)}

--return sidebar_icon
return awful.widget.only_on_screen(sidebar_icon, 'primary')

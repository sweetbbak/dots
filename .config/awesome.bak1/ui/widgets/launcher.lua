-- ## Launcher ##
-- ~~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

-- launcher :
local launcher = wibox.widget{
	widget = wibox.widget.textbox,
	font = theme.ui_font,
	markup = helpers.colorize_text(" ", colors.main_scheme),
	align = "center",
	valign = "center",
}

launcher:buttons(gears.table.join({
	awful.button({ }, 1, function ()
		awful.spawn.with_shell(require("libs.misc").rofiCommand, false)
	end)

}))

return launcher

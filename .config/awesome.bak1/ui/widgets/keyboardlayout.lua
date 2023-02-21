-- ## Keyboard layout ##
-- ~~~~~~~~~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local wibox = require('wibox')
local awful = require("awful")
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

-- Keyboard :
keyboardlayout = awful.widget.keyboardlayout()

-- Icon :
local widget_icon = " "
local icon = wibox.widget{
    font   	= theme.icon_font,
    markup 	= helpers.colorize_text(widget_icon, colors.main_scheme),
    widget 	= wibox.widget.textbox,
    valign 	= "center",
    align 	= "center"
}

return wibox.widget {
	icon,
    wibox.widget{
        keyboardlayout, 
        fg = colors.brightwhite,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}

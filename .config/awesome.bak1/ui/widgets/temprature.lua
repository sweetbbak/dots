-- ## Temprature ##
-- ~~~~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local wibox = require('wibox')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

local temprature = wibox.widget.textbox()
temprature.font = theme.font

watch('bash -c "sensors | awk \'/Core 0/ {print substr($3, 2) }\'"', 30, function(_, stdout)
    temprature.text = stdout
end)


-- Icon :
local widget_icon = " "
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
        temprature, 
        fg = colors.brightwhite,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}

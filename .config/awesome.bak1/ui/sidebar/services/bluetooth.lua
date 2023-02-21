-- ## Bluetooth button/widget ##
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")
local rubato = require("libs.rubato")


-- misc/vars
-- ~~~~~~~~~

local service_name = "Bluetooth"
local service_icon = " "


-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget{
    font   	= theme.sidebar_font,
    markup = helpers.colorize_text(service_icon, colors.white),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "center"
}

-- name
local name = wibox.widget{
    font = theme.font,
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(service_name, colors.white),
    valign = "center",
    align = "center"
}

-- animation :love:
local circle_animate = wibox.widget{
	widget = wibox.container.background,
	shape = helpers.rrect(theme.rounded),
	bg = colors.main_scheme,
	forced_width = 110,
}

-- mix those
local alright = wibox.widget{
    {
		{
			nil,
			{
				circle_animate,
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal,
			expand = "none"
		},
        {
            nil,
            {
                icon,
                name,
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(10)
            },
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        layout = wibox.layout.stack
    },
    shape = helpers.rrect(theme.rounded),
    widget = wibox.container.background,
    border_color = colors.brightblack,
    forced_width = dpi(80),
    forced_height = dpi(80),
    bg = colors.brightblack,
}



local animation_button_opacity = rubato.timed{
	pos = 0,
	rate = 60,
	intro = 0.08,
	duration = 0.3,
	awestore_compat = true,
	subscribed = function(pos)
		circle_animate.opacity = pos
	end
}


-- function that updates everything
local function update_everything(value)
	if value then
		icon.markup = helpers.colorize_text(service_icon, colors.black)
		name.markup = helpers.colorize_text(service_name, colors.black)
		animation_button_opacity:set(1)
	else
		icon.markup = helpers.colorize_text(service_icon, colors.black)
		name.markup = helpers.colorize_text(service_name, colors.black)
		animation_button_opacity:set(0)
	end
end


awesome.connect_signal("signal::bluetooth", function (value, isrun)
    if value then
        update_everything(true)
        alright:buttons(gears.table.join(
            	awful.button( {}, 1, function () 
                    awful.spawn("bluetoothctl power off", false)
                    update_everything(false)
                end)
        	)
        )
    else
        update_everything(false)
        alright:buttons(gears.table.join(
            	awful.button( {}, 1, function ()
                    awful.spawn("bluetoothctl power on", false)
                    update_everything(true)
                end)
        	)
        )
    end
end)

return alright

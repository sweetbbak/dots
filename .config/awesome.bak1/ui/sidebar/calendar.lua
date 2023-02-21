-- ## Calendar ##
-- ~~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require ("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Creating Calendar
----------------------

-- copied from awesome doc and adjusted a bit
local styles = {}

styles.month   = { 
	bg_color = colors.brightblack,
	fg_color = colors.white,
	padding = dpi(3),
}
styles.normal  = { 
	bg_color = colors.brightblack, 
	fg_color = colors.white,
	padding = dpi(3),
}
styles.focus   = { 
	fg_color = colors.yellow,
	markup   = function(t) return '<b>' .. t .. '</b>' end,
	padding = dpi(3),
}
styles.header  = { 
	fg_color = colors.brightblue,
	markup   = function(t) return '<b>' .. t .. '</b>' end,
}
styles.weekday = { 
	fg_color = colors.white,
	markup   = function(t) return '<span font_desc="Roboto Medium 14">' .. t .. '</span>' end,
}

-- The Function
local function decorate_cell(widget, flag, date)
    if flag=="monthheader" and not styles.monthheader then
        flag = "header"
    end

    local props = styles[flag] or {}

    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date("%w", os.time(d)))
    local ret = wibox.widget {
        {
            widget,
            margins = props.padding,
            widget  = wibox.container.margin
        },
        fg           = props.fg_color,
        bg           = props.bg_color,
        widget       = wibox.container.background
    }

    return ret
end

local calendar = wibox.widget {
	date = os.date("*t"),
	font = "Roboto Mono 14",
	start_sunday = true,
	fn_embed = decorate_cell,
	widget = wibox.widget.calendar.month,
}


return wibox.widget {
	nil,
	{
		nil,
		calendar,
		expand = 'none',
		layout = wibox.layout.align.horizontal,
	},
	expand = 'none',
	layout = wibox.layout.align.vertical,
}

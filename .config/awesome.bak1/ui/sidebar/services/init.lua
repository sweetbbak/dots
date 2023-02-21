-- ## Services buttons ##
-- ~~~~~~~~~~~~~~~~~~~~~~
-- each button has a fade animation when activated



-- Requirements :
-- ~~~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")


-- widgets
-- ~~~~~~~
local wifi = require("ui.sidebar.services.wifi")
local bluetooth = require("ui.sidebar.services.bluetooth")
local airplane = require("ui.sidebar.services.airplane")
local night_light = require("ui.sidebar.services.redshift")


-- Bottom setup
local bottom_space = wibox.widget{
        night_light,
        --airplane,
        
        layout = wibox.layout.align.horizontal,
        spacing = dpi(25),
}



-- return
-- ~~~~~~
local returner =  wibox.widget{
	--{
	{
		wifi,
		bluetooth,
		airplane,
		night_light,
		
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(8),
		--expand = "none",
	},
		----bottom_space,
		--spacing = dpi(25),
		--layout = wibox.layout.fixed.vertical,
    --},
	widget = wibox.container.margin,
	margins = {top = dpi(4), bottom = dpi(4), left = dpi(0), right = dpi(0)},
}	

return returner

-- ## Bar ##
-- ~~~~~~~~~

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

-- # Main Bar Widgets :
-- ~~~~~~~~~~~~~~~~~~~~
local taglist = require("ui.bar.taglist")
local tasklist = require("ui.bar.tasklist")
local layoutbox = require("ui.bar.layoutbox")
mylayoutbox = wibox.container.margin(layoutbox(s), dpi(0), dpi(0), dpi(6), dpi(6))
mylauncher = wibox.container.margin(mylauncher, dpi(0), dpi(0), dpi(6), dpi(6))

-- # Widgets :
-- ~~~~~~~~~~~
-- # Sidebar button :
local sidebar_button = require('ui.widgets.sidebar_button')
-- # Systray :
local systray = require('ui.widgets.systray')
-- # Clock : 
local clock_widget = require('ui.widgets.clock')
-- # Keyboard : 
local keyboard_widget = require('ui.widgets.keyboardlayout')
-- # RAM :
local mem_widget = require('ui.widgets.memory')
-- # CPU :
local cpu_widget = require('ui.widgets.cpu')
-- # Temprature :
local temprature_widget = require('ui.widgets.temprature')
-- # Launcher :
local launcher = require('ui.widgets.launcher')


-- # Status widgets :
local status_widgets = wibox.widget {
	{	
		-- # Updates :
		--netspeed_widget,
		-- # CPU TEMP :
		temprature_widget,
		-- # CPU :
		cpu_widget,
		-- # RAM :
		mem_widget,
		-- # Keybord :
		keyboard_widget,
		-- # Clock :
		clock_widget,	
		spacing = dpi(20),
		layout = wibox.layout.fixed.horizontal,
	},
	margins = {top = dpi(4), bottom = dpi(4)},
	widget = wibox.container.margin,
}

-- Bar :
local function get_bar(s)
    -- Create the wibox
	s.mywibar = awful.wibar({
		position = "bottom",
		type = "dock",
		ontop = false,
		stretch = false,
		visible = true,
		height = dpi(42),
		width = s.geometry.width, 
		--width = s.geometry.width - dpi(120),
		screen = s,
		bg = colors.black,
		--bg = colors.main_transparent,
		--bg = colors.transparent,
		--opacity = 0.85,
	})
 
	--awful.placement.bottom(s.mywibar, { margins = theme.useless_gap * 1 })
	--s.mywibar:struts { bottom = dpi(45), top = dpi(0), left = dpi(0), right = dpi(0) }
 
    -- Bar setup :
    s.mywibar:setup {
		{
			{
				{
					{
						launcher,
						taglist(s),
						--tasklist(s),
						spacing = dpi(10),
						layout = wibox.layout.fixed.horizontal
					},
					--nil,
					-- # Tasks in middel :
					{
						tasklist(s),
						--clock_widget,
						layout = wibox.layout.fixed.horizontal
					},
					{
						status_widgets,
						systray,
						sidebar_button,
						mylayoutbox,
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(10)
					},
					layout = wibox.layout.align.horizontal,
					expand = "none"
				},
				widget = wibox.container.margin,
				margins = {left = dpi(15), right = dpi(15), top = dpi(2), bottom = dpi(2)}
			},
			widget = wibox.container.background,
			bg = colors.bg_color,
			forced_height = s.mywibar.height
		},
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(10)
    }  
    
    -- function to remove the bar in maxmized/fullscreen apps
	local function remove_wibar(c)
		if c.fullscreen or c.maximized then
			c.screen.mywibar.visible = false
		else
			c.screen.mywibar.visible = true
		end
    end

    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibar.visible = true
        end
    end
    client.connect_signal("property::fullscreen", remove_wibar)
    client.connect_signal("request::unmanage", add_wibar)
 
end

screen.connect_signal("request::desktop_decoration", function(s)
	get_bar(s)
end)


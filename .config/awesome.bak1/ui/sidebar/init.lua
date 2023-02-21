-- ## Sidebar ##
-- ~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require ("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")
local rubato = require("libs.rubato")


local function center_widget(widgets)
	return wibox.widget {
		nil,
		{
			nil,
			widgets,
			expand = 'none',
			layout = wibox.layout.align.horizontal,
		},
		expand = 'none',
		layout = wibox.layout.align.vertical,
	}
end

local function box_widget(widgets, width, height)
	return wibox.widget {
		{
			{
				widgets,
				margins = dpi(16),
				widget = wibox.container.margin,
			},
			forced_width = dpi(width),
			forced_height = dpi(height),
			shape = helpers.rrect(theme.rounded),
			bg = colors.container,
			widget = wibox.container.background,
		},
		margins = {left = dpi(20), right = dpi(20)},
		widget = wibox.container.margin,
	}
end

-- Get widgets
local profile_widget = require("ui.sidebar.profile")
local player_widget = require("ui.sidebar.player")
local sliders_widget = require("ui.sidebar.sliders")
local weather_widget = require("ui.sidebar.weather")
local calendar_widget = require("ui.sidebar.calendar")
local services_widget = require("ui.sidebar.services")

-- Combine some widgets
local profile = box_widget(profile_widget, 380, 150)
local sliders = box_widget(sliders_widget, 380, 120)
local weather = box_widget(weather_widget, 380, 180)
local player = box_widget(player_widget, 380, 150)
local calendar = box_widget(calendar_widget, 380, 330)
local services = box_widget(services_widget, 380, 200)

-- Spacing
local space = function(height)
	return wibox.widget {
		forced_height = dpi(height),
		layout = wibox.layout.align.horizontal
	}
end


-- Sidebar
local sidebar = wibox {	
	type = "dock",
	--screen  = screen.primary,
	visible = false,
	ontop = true,
	width = dpi(420),
	height = dpi(836),
	y = dpi(8),
	bg = theme.bg,
	--bg = colors.main_transparent,
	shape = helpers.rrect(18),
	
}

-- Sidebar widget setup
sidebar : setup {
	{	
		profile,
		sliders,
		weather,
		player,
		--calendar,
		services,
		
		spacing = dpi(20),
		layout = wibox.layout.fixed.vertical,
	},
	margins = { top = dpi(20), bottom = dpi(20)},
	widget = wibox.container.margin,
}

-- Slide animation
local slide = rubato.timed {
	pos = helpers.screen.geometry.height,
	rate = 60,
	intro = 0.2,
	duration = 0.4,
	subscribed = function(pos) 
		sidebar.y = helpers.screen.geometry.y + pos
	end
}

-- Timer of sidebar's death 
sidebar.timer = gears.timer {
	timeout = 0.5,
	single_shot = true,
	callback = function() 
		sidebar.visible = not sidebar.visible
	end
}

-- Toggle function
sidebar.toggle = function()
	if sidebar.visible then 
		slide.target = helpers.screen.geometry.y - sidebar.height
		sidebar.timer:start()
	else
		slide.target = helpers.screen.geometry.y + dpi(10)
		sidebar.visible = not sidebar.visible
	end
	
end
awful.placement.top_right(sidebar, {honor_workarea = true, margins = beautiful.useless_gap * 3})

--awful.mouse.append_global_mousebindings({
--    awful.button({ }, 1, function () sidebar.toggle() end)
--})
--awful.keyboard.append_global_keybindings({
--	awful.key({alt}, "c", function() awesome.emit_signal("sidebar::toggle") end), -- Sidebar
--})

-- Get signal to execute the function (if that makes sense)
awesome.connect_signal("sidebar::toggle", function(s)
	sidebar.toggle(s)
end)

return sidebar

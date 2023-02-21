-- ## Sliders ##
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

-- Create volume slider :
local volume_icon = wibox.widget{
    font   	= theme.sidebar_font,
    markup 	= helpers.colorize_text("", colors.blue),
    widget 	= wibox.widget.textbox,
    valign 	= "center",
    align 	= "center"
}

local volume_osd_value = wibox.widget({
	text = "0%",
	font = theme.font,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local volume_slider = wibox.widget {
	forced_width = dpi(220),
	forced_height = dpi(10),
	bar_shape = helpers.rrect(dpi(12)),
	bar_height = dpi(14),
	bar_color = colors.black,
	bar_active_color = colors.blue,
	handle_shape = gears.shape.circle,
	handle_color = colors.brightblue,
	handle_width = dpi(20),
	widget = wibox.widget.slider
}

volume = wibox.widget {
	nil,
	{
		volume_icon,
		volume_slider,
		volume_osd_value,
		spacing = dpi(20),
		layout = wibox.layout.fixed.horizontal,
	},
	expand = "none",
	layout = wibox.layout.align.vertical,
}

local update_volume = function() 
	awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout) 
		volume_slider.value = tonumber(stdout:match("%d+"))
	end)
end

volume_slider:connect_signal("property::value", function(_, vol) 
	awful.spawn("pamixer --set-volume ".. vol, false)
	-- Update textbox widget text
	volume_osd_value.text = vol .. "%"
	awesome.emit_signal("module::volume_osd_value", vol)
end)

-- Create Mic slider :
local mic_icon = wibox.widget{
    font   	= theme.sidebar_font,
    markup 	= helpers.colorize_text("  ", colors.green),
    widget 	= wibox.widget.textbox,
    valign 	= "center",
    align 	= "center"
}

local mic_osd_value = wibox.widget({
	text = "0%",
	font = theme.font,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local mic_slider = wibox.widget {
	forced_width = dpi(220),
	forced_height = dpi(10),
	bar_shape = helpers.rrect(dpi(12)),
	bar_height = dpi(14),
	bar_color = colors.black,
	bar_active_color = colors.green,
	handle_shape = gears.shape.circle,
	handle_color = colors.brightgreen,
	handle_width = dpi(20),
	widget = wibox.widget.slider
}

local mic = wibox.widget {
	nil,
	{
		mic_icon,
		mic_slider,
		mic_osd_value,
		spacing = dpi(20),
		layout = wibox.layout.fixed.horizontal,
	},
	expand = "none",
	layout = wibox.layout.align.vertical,
}

local update_mic = function() 
	awful.spawn.easy_async_with_shell("pamixer --source alsa_input.usb-1c1f_USB_PnP_Audio_Device-00.mono-fallback --get-volume", function(stdout) 
		mic_slider.value = tonumber(stdout:match("%d+"))
	end)
end

mic_slider:connect_signal("property::value", function(_, mic_vol) 
	awful.spawn("pamixer --source alsa_input.usb-1c1f_USB_PnP_Audio_Device-00.mono-fallback	--set-volume ".. mic_vol, false)
	-- Update textbox widget text
	mic_osd_value.text = mic_vol .. "%"
	awesome.emit_signal("module::mic_osd_value", mic_vol)
end)

-- Create brightness slider :
local bright_icon = wibox.widget{
    font   	= theme.sidebar_font,
    markup 	= helpers.colorize_text(" ", colors.green),
    widget 	= wibox.widget.textbox,
    valign 	= "center",
    align 	= "center"
}
local bright_osd_value = wibox.widget({
	text = "0%",
	font = theme.font,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local bright_slider = wibox.widget {
	forced_width = dpi(220),
	forced_height = dpi(30),
	bar_shape = helpers.rrect(dpi(12)),
	bar_height = dpi(14),
	bar_color = colors.black,
	bar_active_color = colors.yellow,
	handle_shape = gears.shape.circle,
	handle_color = colors.brightyellow,
	handle_width = dpi(20),
	widget = wibox.widget.slider
}

bright_slider:connect_signal("property::value", function(_, bri) 
	awful.spawn("brightnessctl set "..bri.."%", false)
	bright_osd_value.text = bri .. "%"
	awesome.emit_signal("module::bright_osd_value", bri)
end)

local update_brightness = function()
        awful.spawn.easy_async_with_shell("brightnessctl g", function(stdout)
		val = tonumber(string.format("%.0f", stdout))
			awful.spawn.easy_async_with_shell("brightnessctl max", function(stdout)
				bri = val/tonumber(string.format("%.0f", stdout)) * 100
				bri = tonumber(string.format("%.0f", bri)) or 0
				bright_slider.value = bri
			end)
        end)
end

local brightness = wibox.widget {
        nil,
        {
			bright_icon,
			bright_slider,
			bright_osd_value,
			spacing = dpi(20),
			layout = wibox.layout.fixed.horizontal,
        },
        expand = "none",
        layout = wibox.layout.align.vertical,
}

gears.timer {
	timeout = 10,
	autostart = true,
	call_now = true,
	callback = function() 
		update_volume()
		update_mic()
		update_brightness()
	end
}

local all_slider = wibox.widget {
	volume,
	mic,
	brightness,
	spacing = dpi(10),
	layout = wibox.layout.fixed.vertical,
}

return all_slider

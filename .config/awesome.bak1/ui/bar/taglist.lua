-- ## Tag ##
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

-- Tags :
--awful.util.tagnames =  { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
--awful.util.tagnames =  { "", "", "", "", "", "", "", "", ""} -- font size : 14
awful.util.tagnames =  {"", "", "", "", "", "", "", "", ""}

-- Each screen has its own tag table.
screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
end)

local function update_tag(item, tag, index)
    if tag.selected then
        item.markup = helpers.colorize_text(" 󰮯 ", colors.main_scheme)
    elseif tag.urgent then
        item.markup = helpers.colorize_text("  ", colors.red)
    elseif #tag:clients() > 0 then
        item.markup = helpers.colorize_text("  ", colors.white)
    else
        item.markup = helpers.colorize_text(" 󱙝 ", colors.white)
    end
end

return function(s)

    -- Taglist buttons
    local taglist_buttons = gears.table.join(
		awful.button({ }, 1, function(t) t:view_only() end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),

		awful.button({ }, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end)

		--awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
		--awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
	)

	-- Create a taglist widget
	local taglist = awful.widget.taglist {
		screen  = s,
		--filter  = awful.widget.taglist.filter.all,
		filter = function (t) return t.selected or #t:clients() > 0 end, -- Show only used Tags
		buttons = taglist_buttons,
		layout   = {
			spacing = dpi(8),
			layout = wibox.layout.fixed.horizontal,
		},
		style = {
			spacing = dpi(-4),
		},
		widget_template = {
			id = "tag",
			font = theme.ui_font,
			widget = wibox.widget.textbox,

			create_callback = function(self, c3, index, object)
				update_tag(self, c3, index)
			end,

			update_callback = function(self, c3, index, object) 
				update_tag(self, c3, index)
			end
		}
	}
	
	tags = wibox.widget{
		{
			{
				taglist,
				top = dpi(0),
				bottom = dpi(0),
				left = dpi(8),
				right = dpi(8),
				widget = wibox.container.margin
			},
			bg = colors.container,
			shape = helpers.rrect(theme.rounded - 4),
			widget = wibox.container.background
			},
		top = dpi(4),
		bottom = dpi(4),
		left = dpi(0),
		right = dpi(0),
		widget = wibox.container.margin
	}

	--return taglist
    return tags
end


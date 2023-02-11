local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lgi = require("lgi")
local dpi = beautiful.xresources.apply_dpi

local modkey = modkey or "Mod4"
local spacing = dpi(8)
local font_size = " "..tostring(math.floor(dpi(8)+0.5))
local font = (beautiful.font or "sans")..font_size
local monospace_font = (beautiful.font or "monospace")..font_size
local bg = "#FFFFFF"
local fg = "#6000C0"
local bg_hover = fg.."20"
local bg_press = fg.."40"
local position = "top"

local has_battery = false
do
	local devs = lgi.UPowerGlib.Client():get_devices()
	has_battery = next(devs) ~= nil
end

local recolored_imagebox
do
	local _wibox_old = package.loaded.wibox
	package.loaded.wibox = nil
	local wb = require("wibox")
	recolored_imagebox = wb.widget.imagebox
	recolored_imagebox._old_set_image = recolored_imagebox.set_image
	function recolored_imagebox:set_image(img)
		if self.forced_color then
			img = gears.color.recolor_image(img, self.forced_color)
		end

		self:_old_set_image(img)
	end
	package.loaded.wibox = _wibox_old
end

local function wrapper(widget)
	return {
		{
			widget,
			margins = spacing,
			widget  = wibox.container.margin,
		},
		bg     = bg,
		fg     = fg,
		shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(16)) end,
		widget = wibox.container.background,
	}
end

---@param s screen
local function create_bar(s)
	local bar = awful.wibar {
		type     = "dock",
		position = position,
		height   = dpi(64),
		bg       = gears.color.transparent,
	}

	local calendar_popup = awful.widget.calendar_popup.month {
		style_month = {
			bg_color = bg,
			border_width = 0,
			padding = spacing,
			font = font,
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(16)) end,
		},
		style_header = {
			markup = "<b>%s</b>",
			bg_color = fg,
			fg_color = bg,
			border_width = 0,
			font = font,
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(8)) end,
		},
		style_weekday = {
			bg_color = bg_hover,
			fg_color = fg,
			border_width = 0,
			font = font,
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(8)) end,
		},
		style_focus = {
			markup = "<b>%s</b>",
			bg_color = fg,
			fg_color = bg,
			border_width = 0,
			font = font,
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(8)) end,
		},
		style_normal = {
			bg_color = bg_hover,
			fg_color = fg,
			border_width = 0,
			font = font,
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(8)) end,
		},
	}
	calendar_popup.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(16)) end

	local taglist_widget = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style  = {
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
			squares_sel         = gears.surface(),
			squares_unsel       = gears.surface(),
			squares_sel_empty   = gears.surface(),
			squares_unsel_empty = gears.surface(),
			squares_resize      = gears.surface(),
			bg_focus = fg,
			fg_focus = bg,
			font = font,
		},
		layout = {
			spacing = spacing,
			layout  = wibox.layout.fixed.horizontal
		},
		widget_template = {
			{
				{
					id     = "text_role",
					widget = wibox.widget.textbox,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			id     = "background_role",
			widget = wibox.container.background,
			create_callback = function(self, c3, index, objects)
				local old_cursor, old_wibox

				self:connect_signal("mouse::enter", function()
					self._bg_backup = self.bg
					self._fg_backup = self.fg
					self.bg = bg_hover
					self.fg = fg

					local wb = mouse.current_wibox or {}
					old_cursor, old_wibox = wb.cursor, wb
					wb.cursor = "hand1"
				end)

				self:connect_signal("mouse::leave", function()
					self.bg = self._bg_backup or bg
					self.fg = self._fg_backup or fg

					old_wibox.cursor = old_cursor
					old_wibox = nil
				end)

				self:connect_signal("button::press", function(_,_,_,button)
					self.bg = bg_press
				end)

				self:connect_signal("button::release", function(_,_,_,button)
					self.bg = bg_hover
				end)
			end,
		},
		buttons = {
			awful.button({}, 1, function(t) t:view_only() end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
			awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
		},
	}

	--- The device may not be a laptop, in which case
	--- we also don't need to show the charging percentage
	local battery_label_widget = has_battery and {
		{
			id     = "battery_label_role",
			text   = "???%",
			font   = monospace_font,
			widget = wibox.widget.textbox,
		},
		left   = spacing,
		right  = spacing,
		widget = wibox.container.margin,
	} or nil

	local aweome_icon = beautiful.theme_assets.awesome_icon(dpi(64), fg, bg)
	bar.widget = wibox.widget {
		{
			wrapper {
				{
					awful.widget.launcher {
						image = aweome_icon,
						menu  = awful.menu {
							items = {
								{ "Terminal", terminal or "xterm" },
								{ "Reload", awesome.restart },
								{ "Quit", awesome.quit },
							}
						},
					},
					shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
					widget = wibox.container.background,
				},
				awful.widget.tasklist {
					screen   = s,
					filter   = awful.widget.tasklist.filter.currenttags,
					layout   = {
						spacing = spacing,
						layout  = wibox.layout.fixed.horizontal,
					},
					style = {
						shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
						bg_normal = bg,
						bg_focus = fg,
						bg_urgent = "#FF0044",
					},
					widget_template = {
						{
							{
								id     = "clienticon",
								widget = awful.widget.clienticon,
							},
							margins = dpi(2),
							widget  = wibox.container.margin,
						},
						id     = "background_role",
						widget = wibox.container.background,
						create_callback = function(self, c, index, objects)
							self:get_children_by_id("clienticon")[1].client = c
						end,
					},
					buttons  = {
						awful.button({ }, 1, function (c)
							c:activate { context = "tasklist", action = "toggle_minimization" }
						end),
						awful.button({ }, 3, function() awful.menu.client_list { theme = { width = dpi(250) } } end),
						awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
						awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
					},
				},
				spacing = spacing,
				layout  = wibox.layout.fixed.horizontal,
			},
			margins = spacing,
			widget  = wibox.container.margin,
		},
		nil, -- nothing in the middle
		{ -- right side
			{
				wrapper(taglist_widget),
				wrapper {
					{
						{
							{
								id     = "layout_label_role",
								text   = tostring(awful.layout.getname(awful.layout.get(s))),
								font   = font,
								widget = wibox.widget.textbox,
							},
							left   = spacing,
							right  = spacing,
							widget = wibox.container.margin,
						},
						id     = "layout_label_background_role",
						shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
						widget = wibox.container.background,
					},
					battery_label_widget,
					spacing = spacing,
					layout  = wibox.layout.fixed.horizontal,
				},
				wrapper {
					{
						{
							format = "%H:%M",
							font   = monospace_font,
							widget = wibox.widget.textclock,
						},
						left   = spacing,
						right  = spacing,
						widget = wibox.container.margin,
					},
					id     = "text_clock_background_role",
					shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
					widget = wibox.container.background,
				},
				spacing = spacing,
				layout  = wibox.layout.fixed.horizontal,
			},
			margins = spacing,
			widget  = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal,
	}

	for _, c in ipairs(bar.widget:get_children_by_id("text_clock_background_role")) do
		local old_cursor, old_wibox

		c:connect_signal("mouse::enter", function()
			c.bg = bg_hover
			c.fg = fg

			local wb = mouse.current_wibox or {}
			old_cursor, old_wibox = wb.cursor, wb
			wb.cursor = "hand1"
		end)

		c:connect_signal("mouse::leave", function()
			c.bg = bg
			c.fg = fg

			old_wibox.cursor = old_cursor
			old_wibox = nil
		end)

		c:connect_signal("button::press", function(_,_,_,button)
			if button ~= 1 then
				return
			end

			c.bg = bg_press
		end)

		c:connect_signal("button::release", function(_,_,_,button)
			if button ~= 1 then
				return
			end

			c.bg = bg_hover

			calendar_popup:toggle()
			awful.placement.align(calendar_popup, {
				margins = spacing,
				honor_workarea = true,
				position = position.."_right"
			})
		end)
	end

	local layout_list_popup
	do
		local layout_list_widget = awful.widget.layoutlist {
			screen      = s,
			base_layout = wibox.widget {
				--spacing = spacing,
				layout  = wibox.layout.flex.vertical,
			},
			style = {
				bg_normal = bg,
				fg_normal = fg,
				bg_selected = bg_hover,
				fg_selected = fg,
				shape          = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
				shape_selected = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
			},
			widget_template = {
				{
					{
						{
							{
								{
									id            = "icon_role",
									forced_height = dpi(48),
									forced_width  = dpi(48),
									forced_color  = fg,
									widget        = recolored_imagebox,
								},
								{
									id            = "text_role",
									forced_height = dpi(48),
									widget        = wibox.widget.textbox,
								},
								spacing = spacing,
								layout  = wibox.layout.fixed.horizontal,
							},
							margins = dpi(4),
							widget  = wibox.container.margin,
						},
						id     = "background_role",
						shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(12)) end,
						widget = wibox.container.background,
					},
					margins = dpi(4),
					widget  = wibox.container.margin,
				},
				fg     = fg,
				bg     = bg,
				widget = wibox.container.background,
			},
		}

		layout_list_popup = awful.popup {
			visible        = false,
			ontop          = true,
			minimum_height = #awful.layout.layouts * dpi(48),
			maximum_height = #awful.layout.layouts * dpi(48),
			shape          = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(16)) end,
			bg             = gears.color.transparent,
			widget         = {
				layout_list_widget,
				shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(16)) end,
				widget = wibox.container.background,
			},
		}

		function layout_list_popup:placement_fn()
			local widget_geo = mouse.current_widget_geometry

			awful.placement.align(self, {
				margins = spacing,
				honor_workarea = true,
				position = position.."_right"
			})

			if widget_geo and widget_geo.x and widget_geo.width and self.width then
				self.x = widget_geo.x + widget_geo.width / 2 - self.width / 2 + s. geometry.x / 2
			end
		end

		function layout_list_popup:toggle()
			self.visible = not self.visible

			self:placement_fn()
		end

		layout_list_popup:connect_signal("button::press", function()
			layout_list_popup.visible = false
		end)
	end

	for _, c in ipairs(bar.widget:get_children_by_id("layout_label_background_role")) do
		local old_cursor, old_wibox

		c:connect_signal("mouse::enter", function()
			c.bg = bg_hover
			c.fg = fg

			local wb = mouse.current_wibox or {}
			old_cursor, old_wibox = wb.cursor, wb
			wb.cursor = "hand1"
		end)

		c:connect_signal("mouse::leave", function()
			c.bg = bg
			c.fg = fg

			old_wibox.cursor = old_cursor
			old_wibox = nil
		end)

		c:connect_signal("button::press", function(_,_,_,button)
			if button == 1 or button == 4 then
				awful.layout.inc(1)
			elseif button == 3 then
				layout_list_popup:toggle()
			elseif button == 5 then
				awful.layout.inc(1)
			else
				return
			end

			c.bg = bg_press
		end)

		c:connect_signal("button::release", function(_,_,_,button)
			if not (button == 1 or button == 4 or button == 3 or button == 5) then
				return
			end

			c.bg = bg_hover
		end)
	end

	do
		local function update_layout_label()
			for _, c in ipairs(bar.widget:get_children_by_id("layout_label_role")) do
				c.text = tostring(awful.layout.getname(awful.layout.get(s)))
			end

			layout_list_popup:placement_fn()
		end

		for _, t in pairs(s.tags) do
			t:connect_signal("property::selected", function()
				update_layout_label()
			end)
			t:connect_signal("property::layout", function()
				update_layout_label()
			end)
		end
	end

	if has_battery then
		local devs = lgi.UPowerGlib.Client():get_devices()
		local dev = devs[1]
		for _, device in pairs(devs) do
			if device:get_object_path():match("/battery_BAT[0-9]+$") then
				print(device:to_text())
				dev = device
				break
			end
		end

		local function update_battery_label()
			local current_juice = 100 * (dev["energy"] / dev["energy-full"])
			local juice_str = tostring(math.floor(current_juice+0.5)).."%"
			while #juice_str < 4 do
				juice_str = " "..juice_str
			end

			for _, c in ipairs(bar.widget:get_children_by_id("battery_label_role")) do
				c.text = juice_str
			end
		end

		update_battery_label()

		dev.on_notify = update_battery_label
	end

	return bar
end

return create_bar

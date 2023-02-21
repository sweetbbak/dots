-- ## Helpers ##
-- ~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


local helpers = {}

-- # Better focused screen :
-- ~~~~~~~~~~~~~~~~~~~~~~~~~
helpers.screen = awful.screen.focused({ client = true, mouse = false })

-- # Markup :
-- ~~~~~~~~~~
function helpers.colorize_text(txt, fg)
    if fg == "" then
		fg = "#ffffff"
    end
    return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

-- # Shapes :
-- ~~~~~~~~~~
-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

-- Create pi
helpers.pie = function(width, height, start_angle, end_angle, radius)
    return function(cr)
        gears.shape.pie(cr, width, height, start_angle, end_angle, radius)
    end
end

-- Create parallelogram
helpers.prgram = function(height, base)
    return function(cr, width)
        gears.shape.parallelogram(cr, width, height, base)
    end
end

-- Create partially rounded rect
helpers.prrect = function(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl,radius)
    end
end

-- Create rounded bar
helpers.rbar = function(width, height)
    return function(cr)
        gears.shape.rounded_bar(cr, width, height)
    end
end

return helpers

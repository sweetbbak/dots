-- ## Layouts ##
-- ~~~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local gears = require("gears")
local awful = require("awful")

-- # Libs :
-- ~~~~~~~~
local bling = require("libs.bling")

--- Custom Layouts
local mstab = bling.layout.mstab
local centered = bling.layout.centered
local equal = bling.layout.equalarea
local deck = bling.layout.deck
local vertical = bling.layout.vertical
local horizontal = bling.layout.horizontal

-- Tag layout :
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        --awful.layout.suit.tile.left,
        mstab,
        --awful.layout.suit.tile.bottom,
        --awful.layout.suit.tile.top,
        --awful.layout.suit.fair,
        --awful.layout.suit.fair.horizontal,
        --awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        --awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        --awful.layout.suit.magnifier,
        --awful.layout.suit.corner.nw,
		centered,
		equal,
		deck,
		--vertical,
		--horizontal,
    })
end)

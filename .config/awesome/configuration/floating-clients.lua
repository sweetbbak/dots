---@diagnostic disable:undefined-global
-- disabled to fix Clip studio paint plus child popups from being forced to center

local awful = require 'awful'

client.connect_signal('request::manage', function (c)
    awful.placement.centered(c, {
        honor_workarea = true
    })
end)
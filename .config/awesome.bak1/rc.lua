-- Standard awesome library
pcall(require, "luarocks.loader")
require("awful.autofocus")
local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")

-- # Themes : 
local theme = require("themes")
beautiful.init(theme)

-- ### Configurations ### -- 

-- # Keybindings :
require("configurations.keybindings")

-- # Layouts :
require("configurations.layouts")

-- # Rules :
require("configurations.rules")


-- ### UI ### -- 

-- # Notifications :
require("ui.notifications")

-- # Titlebars :
require("ui.titlebar")

-- # Menu :
require("ui.menu")

-- # Signals :
require("signals")

-- # Sidebar :
require("ui.sidebar")

-- # Bar :
require("ui.bar")


-- Autorun at startup
awful.spawn.with_shell("bash ~/.config/awesome/configurations/autorun")

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- ## Menu ##
-- ~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local menubar = require("menubar")
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup')


-- # Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "   Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "   Manual", terminal .. " -e man awesome" },
   --{ "  Edit config", editor_cmd .. " " .. awesome.conffile },
   { "   Restart", awesome.restart },
   { "   Quit", function() awesome.quit() end },
}


powermenu = {
	{ "  Lock", function() awful.spawn.with_shell('notify-send "👉 Locking system " && sleep 1 && betterlockscreen -l') end },
	{ "  Logout", function() awful.spawn.with_shell('notify-send "👉 Loging out " && sleep 1 && loginctl terminate-session ${XDG_SESSION_ID-}') end },
	{ "  Sleep", function() awful.spawn.with_shell('notify-send "👉 Suspending 鈴" && sleep 1 && systemctl suspend') end },
	{ "  Hibernate", function() awful.spawn.with_shell('notify-send "👉 Hibernateing " && sleep 1 && systemctl hibernate') end },
	{ "  Reboot", function() awful.spawn.with_shell('notify-send "👉 Rebooting " && sleep 1 && reboot') end },
	{ "  Poweroff", function() awful.spawn.with_shell('notify-send "👉 Powering Off " && sleep 1 && poweroff') end },
} 


mymainmenu = awful.menu(
	{ items = { 
		{ "  Awesome", myawesomemenu },
		{ "  Terminal", terminal },
		{ "  Power Menu", powermenu }
	}
})



mylauncher = awful.widget.launcher({ 
	image = theme.awesome_icon,
	menu = mymainmenu
})


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it


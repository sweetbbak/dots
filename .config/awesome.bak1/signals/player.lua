-- ## Player ##
-- ~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")

-- Script
local title_sc = 'playerctl metadata --format {{title}}' 
local artist_sc = 'playerctl metadata --format "{{artist}}"'
local length_sc = 'playerctl metadata --format "{{duration(position)}}/{{(mpris:length)}}"'
local art_sc = [[playerctl metadata --format "{{mpris:artUrl}}" | sed -e 's/^.......//g']]
local status_sc = 'playerctl metadata --format "{{status}}"'



-- function
local function get_player()
	awful.spawn.easy_async_with_shell(title_sc, function(title)
		awful.spawn.easy_async_with_shell(artist_sc, function(artist)
			awful.spawn.easy_async_with_shell(art_sc, function(length)
				awful.spawn.easy_async_with_shell(status_sc, function(status)
					title = string.gsub(title, "\n", "")
					artist = string.gsub(artist, "\n", "")
					length_sc = string.gsub(art_sc, "\n", "")
					--art = string.gsub(art_sc, "\n", "")
					status = string.gsub(status, "\n", "")
					awesome.emit_signal("signal::player", title, artist, length, status)
				end)
			end)
		end)
	end)
end

gears.timer {
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		get_player()
	end
}

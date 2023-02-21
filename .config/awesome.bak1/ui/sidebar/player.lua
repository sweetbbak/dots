-- ## Minimal music widget ##
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

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
local playerctl = require("libs.bling").signal.playerctl.lib()



-- widgets
----------
-- gradientee music album art
-- - - - - - - - - - - - - - 
local music_art_filter = wibox.widget({
	{
		bg = {
				type = "linear",
				from = { 0, 30 },
				to = { 0, 200},
				stops = { 
					{ 0, colors.transparent}, 
					{ 1, colors.container } 
				},
			},
		forced_height = dpi(85),
		forced_width = dpi(85),
		widget = wibox.container.background,
	},
	direction = "east",
	widget = wibox.container.rotate,
})



-- the different music elements
-- - - - - - - - - - - - - - - 

-- album art
local album_art = wibox.widget{
    widget = wibox.widget.imagebox,
    clip_shape = helpers.rrect(theme.rounded),
    forced_height = dpi(85),
    forced_width = dpi(85),
    image = theme.album_art
}

-- playing yeah?
local playing_or = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Now playing", colors.white),
    font = theme.font,
    align = "left",
    valign = "center"
}

-- song artist
local song_artist = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Unknown", colors.white),
    font = theme.font,
    align = "left",
    valign = "center"
}

-- song name
local song_name = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("None", colors.white),
    font = theme.font,
    align = "left",
    valign = "center"
}

---------------------------------------- eo.Widgets

-- buttons
----------

-- toggle button
local toggle_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", colors.white),
    font = theme.sidebar_font,
    align = "right",
    valign = "center"
}

-- next button
local next_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", colors.white),
    font = theme.sidebar_font,
    align = "right",
    valign = "center"
}

-- prev button
local prev_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", colors.white),
    font = theme.sidebar_font,
    align = "right",
    valign = "center"
}

local music_bar = wibox.widget({
	max_value = 100,
	value = 0,
	background_color = colors.brightblack,
	-- shape = gears.shape.rounded_bar,
	color = colors.main_scheme,
	forced_height = dpi(6),
	forced_width = dpi(100),
	widget = wibox.widget.progressbar,
})


--------------------------------- eo.buttons


-- update widgets
-----------------

-- commands for different actions
local toggle_command = function() playerctl:play_pause() end
local prev_command = function() playerctl:previous() end
local next_command = function() playerctl:next() end


-- make it functional!
toggle_button:buttons(gears.table.join(
    awful.button({}, 1, function() toggle_command() end)))

next_button:buttons(gears.table.join(
    awful.button({}, 1, function() next_command() end)))

prev_button:buttons(gears.table.join(
    awful.button({}, 1, function() prev_command() end)))



-- update widgets
-----------------

-- title, artist, album art
playerctl:connect_signal("metadata", function(_, title, artist, album_path, __, ___, ____)
	if title == "" then
		title = "None"
	end
	if artist == "" then
		artist = "Unknown"
	end
	if album_path == "" then
		album_path = theme.album_art
	end

	album_art:set_image(gears.surface.load_uncached(album_path))
    song_name:set_markup_silently(helpers.colorize_text(title, colors.white))
	song_artist:set_markup_silently(helpers.colorize_text(artist, colors.white))


end)

-- playing/paused/{N/A}
playerctl:connect_signal("playback_status", function(_, playing, __)
	if playing then
        toggle_button.markup = helpers.colorize_text("", colors.white)
	else
        toggle_button.markup = helpers.colorize_text("", colors.white)
	end
end)

-- time elapsed
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
		music_bar.value = (interval_sec / length_sec) * 100
		music_length = length_sec
end)


-- mainbox
-- too messy
------------
local music_box =  wibox.widget {
	{
				{
					album_art,
					music_art_filter,
					layout = wibox.layout.stack,
				},
				{
					{
						{
							playing_or,
							nil,
                    		{	
                     	 	  	{
                     	   			step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                     	     		widget = wibox.container.scroll.horizontal,
                     	       		forced_width = dpi(250),
                     	      		speed = 30,
	                    	    	song_name,
  	                  	    	},
    	                	    {
      	              	        	step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        	            	        widget = wibox.container.scroll.horizontal,
          	          	        	forced_width = dpi(250),
            	        	        speed = 30,
              	      	        	song_artist,
                	    	    },
                  	  	    	spacing = dpi(2),
                    		    layout = wibox.layout.fixed.vertical,
	                    	},
  	               	   		layout = wibox.layout.align.vertical,
    	            		expand = "none"
      	          		},
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(10)
					},
					widget = wibox.container.margin,
					margins = {top = dpi(20), bottom = dpi(20), left = dpi(20), right = dpi(20)},
				},
        layout = wibox.layout.stack,
    },
    widget = wibox.container.background,
    forced_height = dpi(150),
    bg = colors.container,
    border_color = colors.container,
    shape = helpers.rrect(theme.rounded)
}


-- finalize
-----------
return wibox.widget {
	{
		music_box,
		{
        	{
        	    music_bar,
        	    direction = "east",
		    	widget = wibox.container.rotate,
        	    forced_width = dpi(2)
        	},
        	layout = wibox.layout.fixed.horizontal,
        	spacing = dpi(20),
		},
		{
			{
				{
					nil,
 	  			     {
 	    		       	prev_button,
 	     		     	toggle_button,
 	      		  		next_button,
						layout = wibox.layout.fixed.vertical,
 	        			spacing = dpi(22)
		    		},	
					layout = wibox.layout.align.vertical,
					expand = "none"
				},
				left = 17, right = 17,
				widget = wibox.container.margin
			},
			bg = colors.brightblack,
			widget = wibox.container.background,
		},
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(0)
	},
	widget = wibox.container.background,
	bg = colors.container,
	shape = helpers.rrect(theme.rounded)
}


-- eof
------



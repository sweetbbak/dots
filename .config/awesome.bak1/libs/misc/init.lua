-- misc stuff
-- ~~~~~~~~~~
-- includes startup apps, theme changing and more

-- requirements
-- ~~~~~~~~~~~~
local awful = require "awful"
local gfs = require "gears".filesystem.get_configuration_dir()


-- launchers
-- ~~~~~~~~~

return {
    rofiCommand = "rofi -show drun -theme " .. gfs .. "/libs/misc/rofi/config.rasi",
    --musicMenu   = function() require("misc.scripts.Rofi.music-pop").execute() end
}

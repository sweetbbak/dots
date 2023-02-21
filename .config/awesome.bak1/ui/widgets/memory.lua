-- ## Memory ##
-- ~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local wibox = require('wibox')
local beautiful = require('beautiful')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

local memory = wibox.widget.textbox()
memory.font = theme.font

--function round(exact, quantum)
--    local quant,frac = math.modf(exact/quantum)
--    return quantum * (quant + (frac > 0.5 and 1 or 0))
--end
--
--watch('bash -c "free | grep -z Mem.*Swap.*"', 2, function(_, stdout)
--    local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
--        stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
--
--    memory.text = round((used / 1048576), 0.01) .. ' GB'
--    collectgarbage('collect')
--end)

watch([[bash -c "free -h | awk '/^Mem/ { print $3 }' | sed s/i//g"]], 2, function(_, stdout)
    memory.text = stdout
    collectgarbage('collect')
end)


-- Icon :
local widget_icon = " "
local icon = wibox.widget{
    font   	= theme.icon_font,
    markup 	= helpers.colorize_text(widget_icon, colors.main_scheme),
    widget 	= wibox.widget.textbox,
    valign 	= "center",
    align 	= "center"
}

return wibox.widget {
	icon,
    wibox.widget{
        memory, 
        fg = colors.brightwhite,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}

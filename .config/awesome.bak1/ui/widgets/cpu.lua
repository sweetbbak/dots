-- ## Cpu ##
-- ~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

local cpu = wibox.widget.textbox()
local total_prev = 0
local idle_prev = 0

watch([[bash -c "cat /proc/stat | grep '^cpu '"]], 2, function(_, stdout)
    local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    cpu.text =  math.floor(diff_usage) .. '%'
    if diff_usage < 10 then cpu.text = '0' .. cpu.text end

    total_prev = total
    idle_prev = idle
    collectgarbage('collect')
end)



-- Icon :
local widget_icon = " "
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
        cpu, 
        fg = colors.brightwhite,
        widget = wibox.container.background
    },
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}

local bling = require("bling")
local rubato = require("rubato")


local anim_y = rubato.timed {
    pos = 1090,
    rate = 60,
    easing = rubato.quadratic,
    intro = 0.1,
    duration = 0.3,
    awestore_compat = true
}

local anim_x = rubato.timed {
    pos = -970,
    rate = 60,
    easing = rubato.quadratic,
    intro = 0.1,
    duration = 0.3,
    awestore_compat = true
}

local term_scratch = bling.module.scratchpad {
    command = "urxvt -name spad",
    rule = { instance = "spad" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = {x=360, y=90, height=900, width=1200},
    reapply = true,
    dont_focus_before_close  = false,
    rubato = {x = anim_x, y = anim_y}
}

term_scratch:connect_signal("turn_on", function(c) naughty.notify({title = "Turned on!"}) end)


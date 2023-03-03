local ruled = require "ruled"
local awful = require "awful"

local function setup_rules ()
    ruled.client.connect_signal("request::rules", function()
        ruled.client.append_rule {
            id         = "global",
            rule       = { },
            properties = {
                focus     = awful.client.focus.filter,
                raise     = true,
                screen    = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen
            }
        }
        ruled.client.append_rule {
            id       = "floating",
            rule_any = {
                instance = { "copyq", "pinentry" },
                class    = {
                    "Arandr", "Blueman-manager", "mpv", "Krita", "Sxiv", "Nsxiv", "clipstudiopaint.exe", "nsxiv",
                    "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer", "feh"
                },
                name    = {
                    "Event Tester",  -- xev.
                },
                role    = {
                    "AlarmWindow",    -- Thunderbird's calendar.
                    "ConfigManager",  -- Thunderbird's about:config.
                    "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
                    "Pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = { floating = true }
        }
        ruled.client.append_rule {
            id         = "titlebars",
            rule_any   = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = true }
        }
    end)

    ruled.notification.connect_signal("request::rules", function ()
        ruled.notification.append_rule {
            rule = { },
            properties = {
                screen = awful.screen.preferred,
                implicit_timeout = 5,
            }
        }
    end)
end

setup_rules()

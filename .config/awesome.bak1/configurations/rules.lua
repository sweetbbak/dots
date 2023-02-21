-- ## Rules ##
-- ~~~~~~~~~~~

-- Requirements :
-- ~~~~~~~~~~~~~~
local awful = require("awful")
local ruled = require("ruled")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- # Libs :
-- ~~~~~~~~
local helpers = require("libs.helpers")

-- connect to signal
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered
        }
    }
    
    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Steam",
				"XTerm",
				"Virt-manager",
				"VirtualBox Manager",
				"Nm-connection-editor",
				"Xfce4-power-manager-settings",
				"Pavucontrol",
				"Qalculate-gtk",
				"Engrampa",
				"Lxappearance",
				"Gnome-disks",
				"Nitrogen",
				"Nsxiv",
				"Audacious",
				"qt5ct",
				"qt6ct",
				"Kvantum Manager",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",  -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"alsamixer",
				"xtightvncviewer",
				"Gufw Firewall",
				"VPN4Test"
			},
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Center Placement
    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {"Steam", "discord", "markdown_input", "nemo", "thunar", "pcmanfm" },
            instance = {"markdown_input",},
            role = {"GtkFileChooserDialog"}
        },
        properties = {placement = awful.placement.center}
    }
    
    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
            position         = "top_right",
        }
    }
end)

-- Vbox Fix :
client.disconnect_signal("request::geometry", awful.ewmh.client_geometry_requests)


-- Master-Slave layout new client goes to the slave, master is kept
client.connect_signal("manage", function(c)
    -- Similar behavior as other window managers DWM, XMonad.
    -- If you need new slave as master press: ctrl + super + return
    if not awesome.startup then awful.client.setslave(c) end
end)

-- Window opacity
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
	c.opacity = 1
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
	c.opacity = 0.9
end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)
    
-- # Round Corners :
--local function enable_rounding()
--	client.connect_signal("manage", function (c)
--		c.shape = helpers.rrect(dpi(8))
--	end)
--
--	local function no_round_corners (c)
--		if c.fullscreen then
--			c.shape = nil
--		elseif c.maximized then
--			--c.shape = helpers.prrect(beautiful.rounded, true, true, false, false)
--			c.shape = helpers.rrect(dpi(0))
--		else
--			c.shape = helpers.rrect(dpi(8))
--		end
--	end
--end
--enable_rounding()

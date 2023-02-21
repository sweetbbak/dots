---------------------------
-- Default awesome theme --
---------------------------

-- Requirements :
-- ~~~~~~~~~~~~~~
local gcolor = require("gears.color")
local gfs = require("gears.filesystem")
local rnotification = require("ruled.notification")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi



-- Theme Dir :	
local themes_path 							= os.getenv("HOME") .. "/.config/awesome/themes/"

-- Titlebar Dir :
local titlebar_theme 						= "mac"
local titlebar_icon_path 				= os.getenv("HOME") .. "/.config/awesome/themes/icons/titlebar/" .. titlebar_theme .. "/"
local tip = titlebar_icon_path

-- Layout Dir :
local layout_icons 							= "base"
local layout_icon_path 					= os.getenv("HOME") .. "/.config/awesome/themes/icons/layouts/" .. layout_icons .. "/"
local lip 										  = layout_icon_path

-- others Icons :
local other_icon_path 				  = os.getenv("HOME") .. "/.config/awesome/themes/icons/other/"
local oip 										  = other_icon_path


local otis_forest 							= require ("themes.schemes.otis-forest")
local doom 										  = require ("themes.schemes.doom-one")
local gruvbox 									= require ("themes.schemes.gruvbox-dark")
local berry 									  = require ("themes.schemes.berry")
local matcha_sea 								= require ("themes.schemes.matcha-sea")
local matcha_azul 							= require ("themes.schemes.matcha-azul")
local matcha_aliz 							= require ("themes.schemes.matcha-aliz")

-- ## Don''t change the line number 😊
colors = gruvbox
-- #############

theme = {}

-- # Fonts :
--theme.font 										= "iosevka Extended Bold 11"
--theme.font 										= "JetBrains Mono Bold 10"
theme.font 										  = "JetBrainsMono Nerd Font Bold 10"
--theme.font 										= "RobotoMono Nerd Font Bold 11"
-- theme.font 									= "Roboto Regular 11"
theme.taglist_font 							= "JetBrainsMono Nerd Font Bold 10"
theme.icon_font 								= "JetBrainsMono Nerd Font Bold 10"
theme.sidebar_font 							= "JetBrainsMono Nerd Font Bold 10"
theme.ui_font 									= "JetBrainsMono Nerd Font Bold 10"
theme.menu_font									= "JetBrainsMono Nerd Font Bold 10"


-- # Background Colors :
theme.bg_normal 								  = colors.black
theme.bg_focus  								  = colors.brightblack
theme.bg_urgent     							= colors.black
theme.bg_minimize   							= colors.black

-- # Foreground Colors :
theme.fg_normal     							= colors.brightwhite
theme.fg_focus      							= colors.brightwhite
theme.fg_urgent     							= colors.brightred
theme.fg_minimize   							= colors.brightblack

--- Systray
--theme.bg_systray    							= colors.container
theme.systray_icon_spacing					= dpi(12)

-- Taglist :
theme.taglist_spacing 							= dpi(8)
theme.taglist_bg_focus                          = colors.container
theme.taglist_bg_urgent							= colors.container
theme.taglist_bg_empty                          = colors.container
theme.taglist_fg_focus                          = colors.main_scheme
theme.taglist_fg_empty                          = colors.brightblack
theme.taglist_fg_urgent							= colors.brightred


-- Clients :
theme.useless_gap   							  = dpi(4)
theme.gap_single_client 						= true
theme.rounded									      = dpi(8)
theme.border_width  							  = dpi(2)
theme.border_normal                 = colors.black
theme.border_focus                  = colors.main_scheme
theme.border_marked                 = colors.brightblack

-- Tasklist :
theme.tasklist_bg_normal 						= colors.black
theme.tasklist_bg_focus 						= colors.black
theme.tasklist_bg_urgent 						= colors.green
theme.tasklist_plain_task_name 			= true
theme.tasklist_disable_task_name 		= false
theme.tasklist_disable_icon 				= true

-- Notification :
theme.notification_spacing = 20

-- Menu :
theme.submenu									      = " "
theme.menu_bg_normal							  = colors.black
theme.menu_bg_focus								  = colors.brightblack
theme.menu_border_color 						= colors.black
theme.menu_height 								  = dpi(30)
theme.menu_width  								  = dpi(180)

-- Icons :
theme.icon_theme                		= "/usr/share/icons/ePapirus/16x16/apps"
theme.awesome_icon  								= oip .."logoarch.png"
theme.pfp 												  = oip .. "pfp.jpg"
theme.album_art 										= oip .. "album-art.png"
theme.user 												  = string.gsub(os.getenv('USER'), '^%l', string.upper)
theme.hostname 											= "@Neptune"
theme.weather_icon 									= oip .."weather_icon.png"

-- Titlebar :
theme.titlebar_size 								= dpi(20)
theme.titlebar_position 						= "left"
theme.titlebar_bg_focus             = colors.black
theme.titlebar_bg_normal            = colors.black
theme.titlebar_fg_normal            = colors.white
theme.titlebar_fg_focus             = colors.brightwhite

-- Close Button :
theme.titlebar_close_button_normal 	= tip.."close_normal.svg"
theme.titlebar_close_button_focus  	= tip.."close_focus.svg"

-- Minimize Button :
theme.titlebar_minimize_button_normal = tip.."minimize_normal.svg"
theme.titlebar_minimize_button_focus  = tip.."minimize_focus.svg"

-- Ontop Button :
theme.titlebar_ontop_button_normal_inactive 			= tip.."ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive  			= tip.."ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active 				= tip.."ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active  				= tip.."ontop_focus_active.svg"

-- Sticky Button :
theme.titlebar_sticky_button_normal_inactive 			= tip.."sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive  			= tip.."sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active 				= tip.."sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active  				= tip.."sticky_focus_active.svg"

-- Floating Button :
theme.titlebar_floating_button_normal_inactive 		= tip.."floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive  		= tip.."floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active 			= tip.."floating_normal_active.svg"
theme.titlebar_floating_button_focus_active  			= tip.."titlebar/stoplight/floating_focus_active.svg"

-- Maximized Button :
theme.titlebar_maximized_button_normal_inactive 	= tip.."maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive  	= tip.."maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active 		= tip.."maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active  		= tip.."maximized_focus_active.svg"

-- Hovered Close Button
theme.titlebar_close_button_normal_hover 				  = tip.. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover  				  = tip.. "close_focus_hover.svg"

-- Hovered Minimize Buttin
theme.titlebar_minimize_button_normal_hover 			= tip.. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover  			= tip.. "minimize_focus_hover.svg"

-- Hovered Ontop Button
theme.titlebar_ontop_button_normal_inactive_hover 	= tip.. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover  	= tip.. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover 		= tip.. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover  		= tip.. "ontop_focus_active_hover.svg"

-- Hovered Sticky Button
theme.titlebar_sticky_button_normal_inactive_hover 	= tip.. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover  	= tip.. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover 		= tip.. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover  		= tip.. "sticky_focus_active_hover.svg"

-- Hovered Floating Button
theme.titlebar_floating_button_normal_inactive_hover 	= tip.. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover  	= tip.. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover 		= tip.. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover  		= tip.. "floating_focus_active_hover.svg"

-- Hovered Maximized Button
theme.titlebar_maximized_button_normal_inactive_hover = tip.. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = tip.. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover 	= tip.. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover  	= tip.. "maximized_focus_active_hover.svg"

-- Layoutbox icons :
theme.layout_fairh 								= gcolor.recolor_image(lip.. "fairh.png", colors.main_scheme)
theme.layout_fairv 								= gcolor.recolor_image(lip.. "fairv.png", colors.main_scheme)
theme.layout_floating  						= gcolor.recolor_image(lip.. "floating.png", colors.main_scheme)
theme.layout_magnifier 						= gcolor.recolor_image(lip.. "magnifier.png", colors.main_scheme)
theme.layout_max 								  = gcolor.recolor_image(lip.. "max.png", colors.main_scheme)
theme.layout_fullscreen 					= gcolor.recolor_image(lip.. "fullscreen.png", colors.main_scheme)
theme.layout_tilebottom 					= gcolor.recolor_image(lip.. "tilebottom.png", colors.main_scheme)
theme.layout_tileleft   					= gcolor.recolor_image(lip.. "tileleft.png", colors.main_scheme)
theme.layout_tile 								= gcolor.recolor_image(lip.. "tile.png", colors.main_scheme)
theme.layout_tiletop 							= gcolor.recolor_image(lip.. "tiletop.png", colors.main_scheme)
theme.layout_spiral  							= gcolor.recolor_image(lip.. "spiral.png", colors.main_scheme)
theme.layout_dwindle 							= gcolor.recolor_image(lip.. "dwindle.png", colors.main_scheme)
theme.layout_cornernw 						= gcolor.recolor_image(lip.. "cornernw.png", colors.main_scheme)
theme.layout_cornerne 						= gcolor.recolor_image(lip.. "cornerne.png", colors.main_scheme)
theme.layout_cornersw 						= gcolor.recolor_image(lip.. "cornersw.png", colors.main_scheme)
-- Bling :
theme.layout_mstab 								= gcolor.recolor_image(lip.. "mstab.png", colors.main_scheme)
theme.layout_vertical 						= gcolor.recolor_image(lip.. "vertical.png", colors.main_scheme)
theme.layout_horizontal						= gcolor.recolor_image(lip.. "horizontal.png", colors.main_scheme)
theme.layout_centered 						= gcolor.recolor_image(lip.. "centered.png", colors.main_scheme)
theme.layout_equalarea						= gcolor.recolor_image(lip.. "equalarea.png", colors.main_scheme)
theme.layout_deck 								= gcolor.recolor_image(lip.. "deck.png", colors.main_scheme)

return theme

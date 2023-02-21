local menubar = require("menubar")

terminal = "kitty"
explorer = "thunar"
browser = "firefox"
launcher = "/home/sweet/bin/launcher.sh"
editor = os.getenv("EDITOR") or "nvim"
visual_editor = "codium" -- vscode
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4" -- super, the windows key
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal

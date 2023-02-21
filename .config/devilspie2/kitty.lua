--[[
    Hide window title for audacious > Album Art window
]]

function isMatch(appName, windowName)
  if (string.match(get_application_name(), appName) and string.match(get_window_name(), windowName)) then
    return true;
  end
  return false;
end

if (isMatch("kitty", "")) then
  undecorate_window();
end

local wezterm = require 'wezterm'

local on_linux = function()
    -- Based on https://stackoverflow.com/a/3652420
    local f = io.popen("uname")
    local output = f:read("*a")
    f:close()
    return output == "Linux\n"
end

-- Workspace mgmt. Src: https://wezfurlong.org/wezterm/config/lua/keyassignment/SwitchWorkspaceRelative.html
wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)

return {
    -- System bash in macOS os old. Let's use the homebrew one if not on Linux.
    default_prog = on_linux() and {"/bin/bash", "-l",} or {"/usr/local/bin/bash", "-l",},

    color_scheme = "Gruvbox Dark",

    -- Custom keybindings
    keys = {
        {key="9", mods="ALT", action=wezterm.action{ShowLauncherArgs={flags="FUZZY|WORKSPACES"}}},
        {key="n", mods="ALT", action=wezterm.action{SwitchWorkspaceRelative=1}},
        {key="p", mods="ALT", action=wezterm.action{SwitchWorkspaceRelative=-1}},
        {key="w", mods="ALT|CMD", action=wezterm.action{CloseCurrentPane={confirm=true}}},
        {key="w", mods="CTRL|SHIFT|ALT", action=wezterm.action{CloseCurrentPane={confirm=true}}},
    },

    -- Borders
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    -- Fonts
    -- The default font is the bundled JetBrains Mono. Some time ago it lacked the nerd glyphs required by nvim-tree, but nowadays it seems this was fixed.

    -- Change font size without messing up OS window layout.
    adjust_window_size_when_changing_font_size = false,

    -- The default font size (10.0) is too small on 4K screens.
    font_size = 18.0,
}

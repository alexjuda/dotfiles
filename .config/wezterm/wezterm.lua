local wezterm = require 'wezterm'

-- Workspace mgmt. Src: https://wezfurlong.org/wezterm/config/lua/keyassignment/SwitchWorkspaceRelative.html
wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)

return {
    -- Override shell. System bash in macOS os old. Let's use the homebrew one.
    default_prog = {"/usr/local/bin/bash", "-l",},

    -- Custom keybindings
    keys = {
        {key="9", mods="ALT", action=wezterm.action{ShowLauncherArgs={flags="FUZZY|WORKSPACES"}}},
        {key="n", mods="ALT", action=wezterm.action{SwitchWorkspaceRelative=1}},
        {key="p", mods="ALT", action=wezterm.action{SwitchWorkspaceRelative=-1}},
        {key="w", mods="ALT|CMD", action=wezterm.action{CloseCurrentPane={confirm=true}}},
        {key="w", mods="CTRL|SHIFT|ALT", action=wezterm.action{CloseCurrentPane={confirm=true}}},
  },
}

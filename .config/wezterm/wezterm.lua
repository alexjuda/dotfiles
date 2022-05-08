local wezterm = require 'wezterm'

-- Workspace mgmt. Src: https://wezfurlong.org/wezterm/config/lua/keyassignment/SwitchWorkspaceRelative.html
wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)

return {
  keys = {
    {key="9", mods="ALT", action=wezterm.action{ShowLauncherArgs={flags="FUZZY|WORKSPACES"}}},
    {key="n", mods="ALT", action=wezterm.action{SwitchWorkspaceRelative=1}},
    {key="p", mods="ALT", action=wezterm.action{SwitchWorkspaceRelative=-1}},
  },
}

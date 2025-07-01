local wezterm = require 'wezterm'
local act = wezterm.action

local on_linux = function()
    -- Based on https://stackoverflow.com/a/3652420
    local f = io.popen("uname")
    local output = f:read("*a")
    f:close()
    return output == "Linux\n"
end

local function scheme_for_appearance(appearance)
    -- Based on https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
    if appearance:find 'Dark' then
        -- return 'Builtin Solarized Dark'
        -- return 'ayu'
        return 'Catppuccin Mocha'
    else
        return 'Github'
    end
end

return {
    -- Determine colorscheme based on System-reported light/dark appearance.
    color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
    -- Custom keybindings
    keys = {
        { key = "w", mods = "CTRL|SHIFT|ALT", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
        -- Imitate moving between panes as in Kitty.
        { key = "{", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Prev") },
        { key = "}", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Next") },
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
    font_size = 16,

    -- Stop "WezTerm Update Available" spam on new panes. Flatpak distribution
    -- is few releases behind so it's impossible to install the latest version.
    check_for_updates = false,
}

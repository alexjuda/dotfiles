local wezterm = require 'wezterm'
local act = wezterm.action

local function scheme_for_appearance(appearance)
    -- Based on https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
    -- It's best when this fits the neovim config.
    if appearance:find 'Dark' then
        return "Ayu Mirage"
    else
        return "ayu_light"
    end
end

local config = wezterm.config_builder()
config:set_strict_mode(true)

-- Determine colorscheme based on System-reported light/dark appearance.
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Custom keybindings
config.keys = {
    { key = "w", mods = "CTRL|SHIFT|ALT", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    -- Imitate moving between panes as in Kitty.
    { key = "{", mods = "CTRL|SHIFT",     action = act.ActivatePaneDirection("Prev") },
    { key = "}", mods = "CTRL|SHIFT",     action = act.ActivatePaneDirection("Next") },
    -- Imitate splitting panes as in Ghostty.
    { key = "e", mods = "CTRL|SHIFT",     action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "o", mods = "CTRL|SHIFT",     action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
}

-- Borders
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Change font size without messing up OS window layout.
-- config.adjust_window_size_when_changing_font_size = false

-- The default font size (10.0) is too small on 4K screens.
config.font_size = 18

-- The default window size for new windows seems small.
local default_size = { cols = 80, rows = 24 }
config.initial_cols = math.floor(120 / 80 * default_size.cols)
config.initial_rows = math.floor(120 / 80 * default_size.rows)

-- Stop "WezTerm Update Available" spam on new panes. Flatpak distribution
-- is few releases behind so it's impossible to install the latest version.
config.check_for_updates = false

-- Enable zenmode-wezterm integration.
-- https://github.com/folke/zen-mode.nvim?tab=readme-ov-file#wezterm
wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return config

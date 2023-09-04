local wezterm = require "wezterm";
return {
    enable_tab_bar = false,
    font = wezterm.font("Fira Code"),
    font_size = 12.0,
    command_palette_fg_color = "#e5e9f0",
    command_palette_bg_color = "#434c5e",
    color_scheme = "nord",
    enable_wayland = false,
    keys = {
        {
            key = "n",
            mods = "SHIFT|CTRL",
            action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
        }, {
        key = "m",
        mods = "SHIFT|CTRL",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
    },
        {
            key = "h",
            mods = "SHIFT|CTRL",
            action = wezterm.action.ActivatePaneDirection "Left"
        },
        {
            key = "l",
            mods = "SHIFT|CTRL",
            action = wezterm.action.ActivatePaneDirection "Right"
        },
        {
            key = "j",
            mods = "SHIFT|CTRL",
            action = wezterm.action.ActivatePaneDirection "Down"
        },
        {
            key = "k",
            mods = "SHIFT|CTRL",
            action = wezterm.action.ActivatePaneDirection "Up"
        }, {
        key = "q",
        mods = "SHIFT|CTRL",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    }

    }
}

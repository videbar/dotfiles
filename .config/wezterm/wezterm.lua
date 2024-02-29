-- Inspired by: https://github.com/theopn/dotfiles/blob/main/wezterm/wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.font = wezterm.font("Fira Code")
config.font_size = 11.0
config.command_palette_fg_color = "#7dcfff"
config.command_palette_bg_color = "#1f2335"
config.color_scheme = "tokyonight_storm"
config.default_workspace = "main"
config.enable_wayland = false
config.disable_default_key_bindings = true

local function workspace_navigator()
    -- Returns a custom workspace navigator.
    return wezterm.action_callback(function(window, pane)
        local workspaces = wezterm.mux.get_workspace_names()
        local choices = {}
        -- Keeps track of whether or not the default workspace is opened. Used so that
        -- the default always appears at the top of the navigator.
        local has_default = false
        for _, ws in ipairs(workspaces) do
            if ws == config.default_workspace then
                has_default = true
            else
                table.insert(choices, { label = ws, id = ws })
            end
        end
        if has_default then
            table.insert(choices, 1, {
                label = config.default_workspace,
                id = config.default_workspace,
            })
        end
        table.insert(choices, {
            label = wezterm.format({
                { Attribute = { Intensity = "Bold" } },
                { Text = "Create new workspace" },
            }),
            id = "new",
        })
        window:perform_action(
            act.InputSelector({
                title = "Workspaces",
                choices = choices,
                action = wezterm.action_callback(
                    function(_sub_window, _sub_pane, id, _label)
                        if id == nil then
                            return
                        elseif id == "new" then
                            window:perform_action(act.SwitchToWorkspace, pane)
                        else
                            wezterm.mux.set_active_workspace(id)
                        end
                    end
                ),
            }),
            pane
        )
    end)
end

local function try_move_or_split(direction)
    -- Try to move to a pane situated in a given direction. If there is no pane, create
    -- a new one.
    return wezterm.action_callback(function(window, pane)
        local current_tab = window:active_tab()
        if current_tab:get_pane_direction(direction) == nil then
            wezterm.log_info(direction .. " is nil")
            window:perform_action(act.SplitPane({ direction = direction }), pane)
        else
            wezterm.log_info("Moving " .. direction)
            window:perform_action(act.ActivatePaneDirection(direction), pane)
        end
    end)
end

-- Keys
config.leader = { key = "phys:Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
    { key = "c", mods = "LEADER", action = wezterm.action.ActivateCopyMode },

    -- Paste from the clipboard
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },

    { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },
    -- Panes
    {
        key = "s",
        mods = "LEADER",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "v",
        mods = "LEADER",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    { key = "h", mods = "LEADER", action = try_move_or_split("Left") },
    { key = "j", mods = "LEADER", action = try_move_or_split("Down") },
    { key = "k", mods = "LEADER", action = try_move_or_split("Up") },
    { key = "l", mods = "LEADER", action = try_move_or_split("Right") },
    { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
    -- Tabs
    {
        key = "r",
        mods = "LEADER",
        action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
    },
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "u", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "i", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "e", mods = "LEADER", action = act.ShowTabNavigator },
    -- Workspaces
    { key = "w", mods = "LEADER", action = workspace_navigator() },
    { key = "n", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
    { key = "p", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
}

config.key_tables = {
    resize_pane = {
        { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
        { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter", action = "PopKeyTable" },
        { key = "q", action = "PopKeyTable" },
        { key = "c", mods = "CTRL", action = "PopKeyTable" },
    },
}

return config

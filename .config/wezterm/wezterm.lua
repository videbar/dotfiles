-- Inspired by: https://github.com/theopn/dotfiles/blob/main/wezterm/wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()
local function generate_new_workspace_name()
    return "Created on " .. os.date("%Y/%m/%d - %H:%M:%S")
end

config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.font = wezterm.font("Fira Code")
config.font_size = 11.0
config.command_palette_fg_color = "#2ac3de"
config.command_palette_bg_color = "#292e42"
config.color_scheme = "rose-pine"
config.default_workspace = generate_new_workspace_name()
config.enable_wayland = false
config.disable_default_key_bindings = true

local function workspace_navigator()
    -- Returns a custom workspace navigator.
    return wezterm.action_callback(function(window, pane)
        local workspaces = wezterm.mux.get_workspace_names()
        local choices = {}
        for _, ws in ipairs(workspaces) do
            table.insert(choices, { label = ws, id = ws })
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
                    function(sub_window, sub_pane, id, label)
                        if id == nil then
                            return
                        elseif id == "new" then
                            window:perform_action(
                                act.SwitchToWorkspace({
                                    name = generate_new_workspace_name(),
                                }),
                                pane
                            )
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

local function set_active_workspace_by_number(n)
    return wezterm.action_callback(function(window, pane)
        local workspaces = wezterm.mux.get_workspace_names()
        if n > #workspaces then
            wezterm.log_info("The value of n is too high")
            return
        end
        wezterm.log_info("Workspaces:\n", workspaces)
        wezterm.mux.set_active_workspace(workspaces[n])
    end)
end

local function try_split_or_unzoom(direction)
    -- If the current pane is zoomed, unzoom it, otherwise split it.
    return wezterm.action_callback(function(window, pane)
        local id = pane:pane_id()
        local panes_info = window:active_tab():panes_with_info()
        for _, info in ipairs(panes_info) do
            if info.pane:pane_id() == id then
                if info.is_zoomed then
                    wezterm.log_info("Pane is zoomed")
                    window:perform_action(act.SetPaneZoomState(false), pane)
                else
                    wezterm.log_info("Pane is not zoomed, splitting " .. direction)
                    pane:split({ direction = direction })
                end
                return
            end
        end
    end)
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
    local current_workspace = wezterm.mux.get_active_workspace()
    local workspace_idx = 0
    local all_workspaces = wezterm.mux.get_workspace_names()
    for i, ws in ipairs(all_workspaces) do
        if ws == current_workspace then
            workspace_idx = i
            break
        end
    end
    local zoomed = ""

    if tab.active_pane.is_zoomed then
        zoomed = "[Z] "
    end
    local workspace_str = string.format("[%d/%d] ", workspace_idx, #all_workspaces)

    return zoomed .. workspace_str .. tab.active_pane.title
end)

-- Keys
config.leader = { key = "phys:Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },

    { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },
    -- Panes
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

    { key = "v", mods = "LEADER", action = try_split_or_unzoom("Right") },
    { key = "s", mods = "LEADER", action = try_split_or_unzoom("Bottom") },

    { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
    {
        key = "r",
        mods = "LEADER",
        action = act.ActivateKeyTable({
            name = "resize_pane",
            one_shot = false,
            until_unknown = true,
        }),
    },
    -- Workspaces
    { key = "w", mods = "LEADER", action = workspace_navigator() },
    { key = "n", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
    { key = "p", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
    {
        mods = "LEADER",
        key = "e",
        action = wezterm.action_callback(function(window, pane)
            window:perform_action(
                act.SwitchToWorkspace({
                    name = generate_new_workspace_name(),
                }),
                pane
            )
        end),
    },
    { key = "1", mods = "LEADER", action = set_active_workspace_by_number(1) },
    { key = "2", mods = "LEADER", action = set_active_workspace_by_number(2) },
    { key = "3", mods = "LEADER", action = set_active_workspace_by_number(3) },
    { key = "4", mods = "LEADER", action = set_active_workspace_by_number(4) },
    { key = "5", mods = "LEADER", action = set_active_workspace_by_number(5) },
    { key = "6", mods = "LEADER", action = set_active_workspace_by_number(6) },
    { key = "7", mods = "LEADER", action = set_active_workspace_by_number(7) },
    { key = "8", mods = "LEADER", action = set_active_workspace_by_number(8) },
    { key = "9", mods = "LEADER", action = set_active_workspace_by_number(9) },
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

-- If a local config file is available, let it overwrite these values.
local function merge_configs(final_config, local_config)
    for k, v in pairs(local_config) do
        if (type(v) == "table") and (type(final_config[k] or false) == "table") then
            merge_configs(final_config[k], local_config[k])
        else
            wezterm.log_info(string.format("Using %s from local config", k))
            final_config[k] = v
        end
    end
    return final_config
end

local local_available, local_config = pcall(require, "local_wezterm")
if local_available and type(local_config) == "table" then
    wezterm.log_info("Found local config")
    merge_configs(config, local_config)
end

return config

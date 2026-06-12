local app_icons = require("helpers.app_icons")

local aerospace = {}

-- Resolve the aerospace CLI to an absolute path. On casks-disabled machines the
-- CLI lives in ~/.local/bin, which is NOT on the minimal PATH that AeroSpace (a
-- login GUI app) hands to the sketchybar process it launches — so bare
-- "aerospace" calls fail and the bar renders empty. Prefer the absolute path
-- when present; fall back to PATH lookup on cask machines (CLI in /opt/homebrew/bin).
local function resolve_aerospace_bin()
    local home = os.getenv("HOME")
    if home then
        local p = home .. "/.local/bin/aerospace"
        local f = io.open(p, "r")
        if f then f:close(); return p end
    end
    return "aerospace"
end
aerospace.bin = resolve_aerospace_bin()

-- Get all workspace IDs (synchronous version using io.popen for initialization)
function aerospace.list_workspaces()
    local workspaces = {}
    local handle = io.popen(aerospace.bin .. " list-workspaces --all")
    if handle then
        for line in handle:lines() do
            local workspace = line:gsub("%s+", "")
            if workspace ~= "" then
                table.insert(workspaces, workspace)
            end
        end
        handle:close()
    end
    return workspaces
end

-- Get the currently focused workspace (synchronous)
function aerospace.get_focused_workspace()
    local handle = io.popen(aerospace.bin .. " list-workspaces --focused")
    if handle then
        local workspace = handle:read("*l")
        handle:close()
        if workspace then
            return workspace:gsub("%s+", "")
        end
    end
    return nil
end

-- Get all windows in a specific workspace (synchronous)
function aerospace.list_windows(workspace)
    local windows = {}
    local handle = io.popen(aerospace.bin .. " list-windows --workspace " .. workspace .. " --format '%{app-name}'")
    if handle then
        for line in handle:lines() do
            local app = line:gsub("%s+", "")
            if app ~= "" then
                table.insert(windows, app)
            end
        end
        handle:close()
    end
    return windows
end

-- Get app icons for windows in a workspace
function aerospace.get_workspace_app_icons(workspace)
    local windows = aerospace.list_windows(workspace)
    local icon_line = ""
    local app_counts = {}

    -- Count occurrences of each app
    for _, app in ipairs(windows) do
        app_counts[app] = (app_counts[app] or 0) + 1
    end

    -- Build icon string
    for app, count in pairs(app_counts) do
        local lookup = app_icons[app]
        local icon = lookup or app_icons["Default"]
        icon_line = icon_line .. icon
    end

    -- Return dash if no apps
    if icon_line == "" then
        icon_line = " —"
    end

    return icon_line
end

-- Check if a workspace is focused
function aerospace.is_workspace_focused(workspace)
    local focused = aerospace.get_focused_workspace()
    return focused == workspace
end

return aerospace

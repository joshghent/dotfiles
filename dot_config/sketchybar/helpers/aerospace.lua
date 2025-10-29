local app_icons = require("helpers.app_icons")

local aerospace = {}

-- Get all workspace IDs (synchronous version using io.popen for initialization)
function aerospace.list_workspaces()
    local workspaces = {}
    local handle = io.popen("aerospace list-workspaces --all")
    if handle then
        for workspace in handle:lines() do
            workspace = workspace:gsub("%s+", "")
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
    local handle = io.popen("aerospace list-workspaces --focused")
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
    local handle = io.popen("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}'")
    if handle then
        for app in handle:lines() do
            app = app:gsub("%s+", "")
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

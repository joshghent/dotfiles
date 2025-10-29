local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local aerospace = require("helpers.aerospace")

local spaces = {}
local space_brackets = {}
local space_paddings = {}

-- Get all workspaces from Aerospace
local workspaces = aerospace.list_workspaces()

-- Create a space item for each Aerospace workspace
for _, workspace_id in ipairs(workspaces) do
    local space = sbar.add("item", "space." .. workspace_id, {
        icon = {
            font = { family = settings.font.numbers },
            string = workspace_id,
            padding_left = 8,
            padding_right = 4,
            color = colors.white,
            highlight_color = colors.red,
        },
        label = {
            padding_right = 8,
            color = colors.grey,
            highlight_color = colors.white,
            font = "sketchybar-app-font:Regular:16.0",
            y_offset = -1,
            string = " —",
        },
        padding_right = 1,
        padding_left = 1,
        background = {
            color = colors.bg1,
            border_width = 1,
            height = 26,
            border_color = colors.black,
        },
    })

    spaces[workspace_id] = space

    -- Single item bracket for space items to achieve double border on highlight
    local space_bracket = sbar.add("bracket", { space.name }, {
        background = {
            color = colors.transparent,
            border_color = colors.bg2,
            height = 28,
            border_width = 2
        }
    })
    space_brackets[workspace_id] = space_bracket

    -- Padding space
    local space_padding = sbar.add("item", "space.padding." .. workspace_id, {
        width = settings.group_paddings,
    })
    space_paddings[workspace_id] = space_padding

    -- Click handler to switch workspaces
    space:subscribe("mouse.clicked", function(env)
        sbar.exec("aerospace workspace " .. workspace_id)
    end)
end

-- Function to update all workspace labels with app icons and visibility
local function update_workspace_icons()
    for _, workspace_id in ipairs(workspaces) do
        local windows = aerospace.list_windows(workspace_id)
        local has_windows = #windows > 0
        local icon_line = aerospace.get_workspace_app_icons(workspace_id)

        if spaces[workspace_id] and space_brackets[workspace_id] and space_paddings[workspace_id] then
            sbar.animate("tanh", 10, function()
                spaces[workspace_id]:set({
                    label = icon_line,
                    drawing = has_windows
                })
                space_brackets[workspace_id]:set({
                    drawing = has_windows
                })
                space_paddings[workspace_id]:set({
                    drawing = has_windows
                })
            end)
        end
    end
end

-- Function to update workspace highlighting
local function update_workspace_focus(focused_workspace)
    for _, workspace_id in ipairs(workspaces) do
        if spaces[workspace_id] and space_brackets[workspace_id] then
            local is_focused = (workspace_id == focused_workspace)
            spaces[workspace_id]:set({
                icon = { highlight = is_focused },
                label = { highlight = is_focused },
                background = { border_color = is_focused and colors.black or colors.bg2 }
            })
            space_brackets[workspace_id]:set({
                background = { border_color = is_focused and colors.grey or colors.bg2 }
            })
        end
    end
end

-- Subscribe to aerospace workspace change event
local aerospace_observer = sbar.add("item", {
    drawing = false,
    updates = true,
})

aerospace_observer:subscribe("aerospace_workspace_change", function(env)
    local focused_workspace = env.FOCUSED_WORKSPACE
    update_workspace_focus(focused_workspace)
    update_workspace_icons()
end)

-- Initial update
local focused = aerospace.get_focused_workspace()
if focused then
    update_workspace_focus(focused)
end
update_workspace_icons()

-- Spaces indicator (for menu swap feature)
local spaces_indicator = sbar.add("item", {
    padding_left = -3,
    padding_right = 0,
    label = {
        width = 0,
        padding_left = 0,
        padding_right = 8,
        string = "Spaces",
        color = colors.transparent,
    },
    background = {
        color = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.transparent, 0.0),
    }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
    local currently_on = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({
        icon = currently_on and icons.switch.off or icons.switch.on
    })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = { alpha = 1.0 },
                border_color = { alpha = 1.0 },
            },
            icon = { color = colors.bg1 },
            label = { width = "dynamic" }
        })
    end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = { alpha = 0.0 },
                border_color = { alpha = 0.0 },
            },
            icon = { color = colors.grey },
            label = { width = 0, }
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)

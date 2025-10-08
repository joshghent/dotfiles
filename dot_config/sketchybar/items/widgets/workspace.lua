local colors = require("colors")
local settings = require("settings")

local workspace = sbar.add("item", "widgets.workspace", {
    position = "right",
    icon = { drawing = false },
    label = {
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 16.0,
        },
        string = "?",
        color = colors.white,
        padding_left = 4,
        padding_right = 4
    },
    background = { color = colors.bg1 },
})

local function update_workspace()
    sbar.exec("aerospace list-workspaces --focused", function(result)
        local current_workspace = result:gsub("%s+", "")
        workspace:set({
            label = { string = current_workspace }
        })
    end)
end

-- Subscribe to aerospace workspace change events
workspace:subscribe("aerospace_workspace_change", update_workspace)

-- Initial update
update_workspace()

sbar.add("item", { position = "right", width = settings.group_paddings })

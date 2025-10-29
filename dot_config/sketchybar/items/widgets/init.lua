require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.workspace")

local colors = require("colors")

-- Add a bracket around all right-side widgets with a grey background
sbar.add("bracket", { "widgets.workspace", "widgets.volume", "widgets.battery.percentage", "widgets.battery.icon", "cal" }, {
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        border_width = 2
    }
})

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Define all possible workspaces
local all_workspaces = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "I", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

local spaces = {}

-- Create space items for all workspaces
for _, workspace_id in ipairs(all_workspaces) do
  local space = sbar.add("space", "space." .. workspace_id, {
    space = workspace_id,
    icon = {
      font = { family = settings.font.numbers },
      string = workspace_id,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
    drawing = false, -- Start hidden
  })

  spaces[workspace_id] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2
    },
    drawing = false, -- Start hidden
  })

  -- Padding space
  sbar.add("space", "space.padding." .. workspace_id, {
    space = workspace_id,
    script = "",
    width = settings.group_paddings,
    drawing = false, -- Start hidden
  })

  -- Update the space with current apps
  local function update_space_apps()
    sbar.exec("aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'", function(apps_output)
      local icon_line = ""
      local app_count = 0
      local has_windows = false

      for app in apps_output:gmatch("[^\r\n]+") do
        if app and app ~= "" then
          app_count = app_count + 1
          has_windows = true
          local lookup = app_icons[app]
          local icon = ((lookup == nil) and app_icons["Default"] or lookup)
          icon_line = icon_line .. icon
        end
      end

      if app_count == 0 then
        icon_line = " —"
      end

      -- Show/hide space based on whether it has windows
      space:set({
        label = { string = icon_line },
        drawing = has_windows
      })
      space_bracket:set({ drawing = has_windows })
      sbar.set("space.padding." .. workspace_id, { drawing = has_windows })
    end)
  end

  -- Initial update
  update_space_apps()

  space:subscribe("mouse.clicked", function(env)
    sbar.exec("aerospace workspace " .. workspace_id)
  end)
end

-- Add events for aerospace
sbar.add("event", "aerospace_workspace_change")

-- Handle workspace changes from aerospace
sbar.add("item", "aerospace_listener", {
  position = "popup.aerospace_listener",
  drawing = false,
}):subscribe("aerospace_workspace_change", function(env)
  local focused_workspace = env.FOCUSED_WORKSPACE

  -- Use a single aerospace command to get all windows
  sbar.exec("aerospace list-windows --all --format '%{workspace}:%{app-name}'", function(windows_output)
    -- Build a table of workspace -> app list
    local workspace_apps = {}
    for line in windows_output:gmatch("[^\r\n]+") do
      local workspace, app = line:match("^([^:]+):(.+)$")
      if workspace and app and app ~= "" then
        if not workspace_apps[workspace] then
          workspace_apps[workspace] = {}
        end
        table.insert(workspace_apps[workspace], app)
      end
    end

    -- Update all spaces
    for workspace_id, space in pairs(spaces) do
      local apps = workspace_apps[workspace_id] or {}
      local icon_line = ""
      local has_windows = #apps > 0

      -- Build icon line from apps
      for _, app in ipairs(apps) do
        local lookup = app_icons[app]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        icon_line = icon_line .. icon
      end

      if #apps == 0 then
        icon_line = " —"
      end

      local selected = (workspace_id == focused_workspace)
      -- Show workspace if it has windows OR if it's the currently focused workspace
      local should_draw = has_windows or selected

      space:set({
        icon = { highlight = selected },
        label = {
          highlight = selected,
          string = icon_line
        },
        background = { border_color = selected and colors.black or colors.bg2 },
        drawing = should_draw
      })

      local bracket_name = "space." .. workspace_id
      sbar.set(bracket_name .. ".bracket", {
        background = { border_color = selected and colors.grey or colors.bg2 },
        drawing = should_draw
      })

      sbar.set("space.padding." .. workspace_id, { drawing = should_draw })
    end
  end)
end)

-- Spaces indicator
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

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

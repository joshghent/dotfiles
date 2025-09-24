local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Get aerospace workspaces that have windows
sbar.exec("aerospace list-workspaces --all | xargs -I {} sh -c 'count=$(aerospace list-windows --workspace {} | wc -l); if [ $count -gt 0 ]; then echo {}; fi'", function(workspaces_output)
  local workspaces = {}
  for workspace in workspaces_output:gmatch("[^\r\n]+") do
    local ws = workspace:gsub("%s+", "")
    if ws and ws ~= "" then
      table.insert(workspaces, ws)
    end
  end

  local spaces = {}

  -- Create space items for each workspace with windows
  for _, workspace_id in ipairs(workspaces) do
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

    -- Padding space
    sbar.add("space", "space.padding." .. workspace_id, {
      space = workspace_id,
      script = "",
      width = settings.group_paddings,
    })

    -- Subscribe to aerospace workspace changes
    space:subscribe("aerospace_workspace_change", function(env)
      -- Get current focused workspace
      sbar.exec("aerospace list-workspaces --focused", function(focused_output)
        local focused_workspace = focused_output:gsub("%s+", "")
        local selected = (workspace_id == focused_workspace)

        space:set({
          icon = { highlight = selected, },
          label = { highlight = selected },
          background = { border_color = selected and colors.black or colors.bg2 }
        })
        space_bracket:set({
          background = { border_color = selected and colors.grey or colors.bg2 }
        })
      end)
    end)

    -- Update the space with current apps
    local function update_space_apps()
      sbar.exec("aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'", function(apps_output)
        local icon_line = ""
        local app_count = 0

        for app in apps_output:gmatch("[^\r\n]+") do
          if app and app ~= "" then
            app_count = app_count + 1
            local lookup = app_icons[app]
            local icon = ((lookup == nil) and app_icons["Default"] or lookup)
            icon_line = icon_line .. icon
          end
        end

        if app_count == 0 then
          icon_line = " —"
        end

        space:set({ label = { string = icon_line } })
      end)
    end

    -- Subscribe to window changes
    space:subscribe("space_windows_change", update_space_apps)

    -- Initial update
    update_space_apps()

    space:subscribe("mouse.clicked", function(env)
      sbar.exec("aerospace workspace " .. workspace_id)
    end)
  end

  -- Initial workspace highlight
  sbar.exec("aerospace list-workspaces --focused", function(focused_output)
    local focused_workspace = focused_output:gsub("%s+", "")
    for workspace_id, space in pairs(spaces) do
      local selected = (workspace_id == focused_workspace)
      space:set({
        icon = { highlight = selected, },
        label = { highlight = selected },
        background = { border_color = selected and colors.black or colors.bg2 }
      })
    end
  end)
end)

-- Add events for aerospace - these need to be triggered by aerospace config
sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "space_windows_change")

-- Create a periodic update for spaces since aerospace might not trigger events
local update_all_spaces = function()
  sbar.exec("aerospace list-workspaces --all | xargs -I {} sh -c 'count=$(aerospace list-windows --workspace {} | wc -l); if [ $count -gt 0 ]; then echo {}; fi'", function(current_workspaces_output)
    -- This will re-create spaces if needed
    -- For now, let's just update existing ones
  end)
end

-- Update every 10 seconds
sbar.exec("(while true; do echo 'space_windows_change'; sleep 10; done) &")

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
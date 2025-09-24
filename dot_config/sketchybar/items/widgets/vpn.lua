local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local vpn = sbar.add("item", "widgets.vpn", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Bold"],
      size = 16.0,
    },
    string = "🔒",
    color = colors.green,
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
    string = "VPN",
    color = colors.green,
  },
  background = { color = colors.bg1 },
  padding_left = 8,
  padding_right = 8,
})

local function update_vpn_status()
  sbar.exec("scutil --nc list | grep 'ch.protonvpn.mac'", function(result)
    local is_connected = result:find("Connected") ~= nil

    vpn:set({
      drawing = is_connected,
      icon = {
        color = is_connected and colors.green or colors.red,
      },
      label = {
        color = is_connected and colors.green or colors.red,
      },
    })
  end)
end

-- Check VPN status every 5 seconds
sbar.add("event", "vpn_update")
sbar.exec("(while true; do echo 'vpn_update'; sleep 5; done) &")

vpn:subscribe("vpn_update", update_vpn_status)

-- Initial check
update_vpn_status()

sbar.add("item", { position = "right", width = settings.group_paddings })
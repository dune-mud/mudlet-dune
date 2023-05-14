--
-- UI specific code.
--
-- Responds to DuneMUD plugin events to manage the user interface components.
--

DuneMUD = DuneMUD or {}
DuneMUD.config = DuneMUD.config or {}
DuneMUD.ui = DuneMUD.ui or {}

local EMCO = require("@PKGNAME@.mdk.emco")

local default_constraints = {
  name = "TopWindow",
  x = "0",
  y = "0", 
  width = "100%",
  height = "200px",
}
local stylesheet = [[background-color: rgb(0,180,0,255); border-width: 1px; border-style: solid; border-color: gold; border-radius: 10px;]]
local istylesheet = [[background-color: rgb(60,60,60,255); border-width: 1px; border-style: solid; border-color: gold; border-radius: 10px;]]

function DuneMUD.ui.setup()
  DuneMUD.ui.container = DuneMUD.ui.container or Adjustable.Container:new(default_constraints)

  DuneMUD.ui.channelEMCO = DuneMUD.ui.channelEMCO or EMCO:new({
    x = "0",
    y = "0",
    width = "100%",
    height = "100%",
    allTab = true,
    allTabName = "all",
    gap = 2,
    consoleColor = "black",
    consoles = {
      "all",
    },
    timestamp = true,
    blink = true,
    activeTabCSS = stylesheet,
    inactiveTabCSS = istylesheet,
  }, DuneMUD.ui.container)
end

function DuneMUD.ui.tearDown()
  DuneMUD.ui.channelEMCO:hide()
  DuneMUD.ui.channelEMCO = nil

  DuneMUD.ui.container:hide()
  DuneMUD.ui.container = nil

  DuneMUD.ui = nil
end

function DuneMUD.ui.onChannelList(_, channelList)
  local channelEMCO = DuneMUD.ui.channelEMCO

  for _, chan_info in ipairs(channelList) do
    local chan_name = chan_info.name
    local chan_enabled = chan_info.enabled

    if chan_enabled == 1 and not table.contains(channelEMCO.consoles, chan_name) then
      channelEMCO:addTab(chan_name)
    end
  end
end

function DuneMUD.ui.onChannelText(_, channelText)
  local channelEMCO = DuneMUD.ui.channelEMCO

  local chan_name = channelText.channel
  local text = channelText.channel_ansi .. " " .. channelText.text

  if not table.contains(channelEMCO.consoles, chan_name) then
    channelEMCO:addTab(chan_name)
  end

  channelEMCO:decho(chan_name, ansi2decho(text))
end


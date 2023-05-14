--
-- UI specific code.
--
-- Responds to DuneMUD plugin events to manage the user interface components.
--

DuneMUD = DuneMUD or {}
DuneMUD.config = DuneMUD.config or {}
DuneMUD.ui = DuneMUD.ui or {}

local EMCO = require("@PKGNAME@.mdk.emco")

local channelsTabStyle = [[
  background-color: rgb(0,180,0,255);
  border-width: 1px;
  border-style: solid;
  border-color: gold; 
  border-radius: 10px;
]]

local inactiveChannelsTabStyle = [[
  background-color: rgb(60,60,60,255);
  border-width: 1px;
  border-style: solid;
  border-color: gold;
  border-radius: 10px;
]]

local function setupBaseLayout()
  DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}
  local GUI = DuneMUD.ui.GUI

  GUI.top = GUI.top or Adjustable.Container:new({
    name = "top",
    y = "0%",
    height = "10%",
    --autoSave = false,
    autoLoad = false,
  })

  GUI.bottom = GUI.bottom or Adjustable.Container:new({
    name = "bottom",
    height = "20%",
    y = "-20%",
    --autoSave = false,
    autoLoad = false,
  })

  GUI.right = GUI.right or Adjustable.Container:new({
    name = "right",
    y = "0%",
    height = "100%",
    x = "-20%",
    width = "20%",
    --autoSave = false,
    autoLoad = false
  })

  GUI.left = GUI.left or Adjustable.Container:new({
    name = "left",
    x = "0%",
    y = "0%",
    height = "100%",
    width = "20%",
    --autoSave = false,
    autoLoad = false
  })
end

local function setupChannels()
  DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}
  local GUI = DuneMUD.ui.GUI

  GUI.channelEMCO = GUI.channelEMCO or EMCO:new({
    x = "0",
    y = "0",
    width = "100%",
    height = "100%",
    allTab = true,
    allTabName = "all",
    gap = 2,
    consoleColor = "black",
    consoles = { "all" }, -- We add the rest dynamically.
    timestamp = true,
    blink = true,
    activeTabCSS = channelsTabStyle,
    inactiveTabCSS = inactiveChannelsTabStyle,
  }, GUI.top)
end

function DuneMUD.ui.setup()
  setupBaseLayout()
  setupChannels()

  DuneMUD.ui.show()
end

function DuneMUD.ui.tearDown()
  DuneMUD.ui.hide()

  DuneMUD.ui.GUI = {}
  DuneMUD.ui = nil
end

function DuneMUD.ui.show()
  local GUI = DuneMUD.ui.GUI

  GUI.top:show()
  GUI.bottom:show()
  GUI.right:show()
  GUI.left:show()

  GUI.top:attachToBorder("top")
  GUI.bottom:attachToBorder("bottom")
  GUI.left:attachToBorder("left")
  GUI.right:attachToBorder("right")

  GUI.top:connectToBorder("left")
  GUI.top:connectToBorder("right")
  GUI.bottom:connectToBorder("left")
  GUI.bottom:connectToBorder("right")

  GUI.channelEMCO:show()
end

function DuneMUD.ui.hide()
  local GUI = DuneMUD.ui.GUI

  GUI.channelEMCO:hide()

  GUI.left:hide()
  GUI.right:hide()
  GUI.bottom:hide()
  GUI.top:hide()
end

function DuneMUD.ui.onChannelList(_, channelList)
  local channelEMCO = DuneMUD.ui.GUI.channelEMCO

  for _, chan_info in ipairs(channelList) do
    local chan_name = chan_info.name
    local chan_enabled = chan_info.enabled

    if chan_enabled == 1 and not table.contains(channelEMCO.consoles, chan_name) then
      channelEMCO:addTab(chan_name)
    end
  end
end

function DuneMUD.ui.onChannelText(_, channelText)
  local channelEMCO = DuneMUD.ui.GUI.channelEMCO

  local chan_name = channelText.channel
  local text = channelText.channel_ansi .. " " .. channelText.text

  if not table.contains(channelEMCO.consoles, chan_name) then
    channelEMCO:addTab(chan_name)
  end

  channelEMCO:decho(chan_name, ansi2decho(text))
end


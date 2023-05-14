--
-- UI specific code.
--
-- Responds to DuneMUD plugin events to manage the user interface components.
--

DuneMUD = DuneMUD or {}
DuneMUD.config = DuneMUD.config or {}
DuneMUD.ui = DuneMUD.ui or {}

local EMCO = require("@PKGNAME@.mdk.emco")

require("@PKGNAME@.tabwindow.tabwindow")

-- Channels we'll create tabs for if the user has the channel enabled.
-- Messages received on other channels will get lumped into the "all" and
-- "other" tabs.
local tabbedChans = {
  chat = true,
  discord = true,
  newbie = true,

  pk = true,

  atreid = true,
  war = true,
  mind = true,
  fremen = true,
  tp = true,
  matres = true,
  sard = true,
  speakers = true,
  eye = true,
  tls = true,
  com = true,
}

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

local containerDefaults = {
  lockStyle = "border",
  autoSave = false,
  locked = true,
  autoLoad = false,
}

local function adjContainer(settings)
  local mergedSettings = table.update(table.deepcopy(containerDefaults), settings)
  return Adjustable.Container:new(mergedSettings)
end

local function setupBaseLayout()
  DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}
  local GUI = DuneMUD.ui.GUI

  GUI.top = GUI.top or adjContainer({
    name = "top",
    y = "0%",
    height = "10%",
  })

  GUI.bottom = GUI.bottom or adjContainer({
    name = "bottom",
    height = "20%",
    y = "-20%",
  })

  GUI.right = GUI.right or adjContainer({
    name = "right",
    y = "0%",
    height = "100%",
    x = "-20%",
    width = "20%",
  })

  GUI.left = GUI.left or adjContainer({
    name = "left",
    x = "0%",
    y = "0%",
    height = "100%",
    width = "20%",
  })
end

-- TODO(@Paradox): break out setting for making tabs for other channels.
local function setupChannels()
  DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}
  local GUI = DuneMUD.ui.GUI

  GUI.channelEMCO = GUI.channelEMCO or EMCO:new({
    x = "5",
    y = "5",
    width = "100%",
    height = "100%",
    allTab = true,
    allTabName = "all",
    gap = 2,
    consoleColor = "black",
    consoles = { "all", "chat", "discord", "other" },
    timestamp = true,
    blink = true,
    activeTabCSS = channelsTabStyle,
    inactiveTabCSS = inactiveChannelsTabStyle,
  }, GUI.top)
end

local function setupVitals()
  DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}
  local GUI = DuneMUD.ui.GUI

  GUI.vitalsWindow = GUI.vitalsWindow or Adjustable.TabWindow:new({
    name = "vitalsWindow",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    tabBarHeight ="10%",
    tabs = {"Tab1", "Tab2", "Tab3"},
  }, GUI.bottom)
end

function DuneMUD.ui.setup()
  setupBaseLayout()
  setupChannels()
  setupVitals()

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
  GUI.vitalsWindow:show()
end

function DuneMUD.ui.hide()
  local GUI = DuneMUD.ui.GUI

  GUI.vitalsWindow:hide()
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

    if chan_enabled == 1 and
       tabbedChans[chan_name] and
       not table.contains(channelEMCO.consoles, chan_name)
    then
      channelEMCO:addTab(chan_name)
    end
  end
end

function DuneMUD.ui.onChannelText(_, channelText)
  local channelEMCO = DuneMUD.ui.GUI.channelEMCO

  local chan_name = channelText.channel
  local text = channelText.channel_ansi .. " " .. channelText.text

  if tabbedChans[chan_name] and
     not table.contains(channelEMCO.consoles, chan_name)
  then
    channelEMCO:addTab(chan_name)
  end

  if tabbedChans[chan_name] then
    channelEMCO:decho(chan_name, ansi2decho(text))
  else
    channelEMCO:decho("other", ansi2decho(text))
  end
end


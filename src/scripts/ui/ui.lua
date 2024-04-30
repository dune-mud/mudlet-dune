--
-- UI specific code.
--
-- Responds to DuneMUD plugin events to manage the user interface components.
--

DuneMUD = DuneMUD or {}
DuneMUD.config = DuneMUD.config or {}
DuneMUD.ui = DuneMUD.ui or {}
DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}

local EMCO = require("@PKGNAME@.mdk.emco")
local SUG = require("@PKGNAME@.mdk.sug")

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
    x = "-20%",
    y = 0,
    height = "100%",
    width = "20%",
  })
end

local function setupChannels()
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

local function getGaugeCss(backgroundColor)
  local res = f[[
		background-color: {backgroundColor};
		border-style: solid;
		border-color: white;
		border-width: 1px;
		border-radius: 5px;
		margin: 5px;
	]]
	return res
end

local function setupVitals()
  local GUI = DuneMUD.ui.GUI

  GUI.vitalsWindow = GUI.vitalsWindow or Adjustable.TabWindow:new({
    name = "vitalsWindow",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    tabBarHeight ="10%",
    tabs = {"Vitals", "Tab 2"},
  }, GUI.bottom)

  GUI.vitalsGaugeBox = GUI.vitalsGaugeBox or Geyser.VBox:new({
    name="vitalsGaugeBox",
    x = 15,
    y = 15,
    height = -15,
    width = -15,
  }, GUI.vitalsWindow.Vitalscenter)

  GUI.hpGauge = GUI.hpGauge or SUG:new({
    name = "hpGauge",
    updateEvent = "gmcp.Char.Vitals",
    textTemplate = "<center>|c/|m HP (|p%)</center>",
    currentVariable = "gmcp.Char.Vitals.hp",
    maxVariable = "gmcp.Char.Vitals.maxhp"
  }, GUI.vitalsGaugeBox)
  GUI.hpGauge.front:setStyleSheet(getGaugeCss("green"))
  GUI.hpGauge.back:setStyleSheet(getGaugeCss("black"))
  GUI.hpGauge:setFontSize(14)
  
  GUI.cpGauge = GUI.cpGauge or SUG:new({
    name = "cpGauge",
    updateEvent = "gmcp.Char.Vitals",
    textTemplate = "<center>|c/|m CP (|p%)</center>",
    currentVariable = "gmcp.Char.Vitals.sp",
    maxVariable = "gmcp.Char.Vitals.maxsp",
  }, GUI.vitalsGaugeBox)
  GUI.cpGauge.front:setStyleSheet(getGaugeCss("goldenrod"))
  GUI.cpGauge.back:setStyleSheet(getGaugeCss("black"))
  GUI.cpGauge:setFontSize(14)

end

local function setupMap()
  local GUI = DuneMUD.ui.GUI

  GUI.map = GUI.map or
    Geyser.Mapper:new({
      x = 5,
      y = "50%",
      width = "100%",
      height = "50%",
      name = "map",
    }, GUI.right)
end

local function setupTopRight()
  local GUI = DuneMUD.ui.GUI

  GUI.topRight = GUI.topRight or Adjustable.TabWindow:new({
    name = "topRight",
    x = 5,
    y = 0,
    width = "100%",
    height = "50%",
    tabBarHeight ="10%",
    tabs = {"Stats", "Cooldowns"},
  }, GUI.right)
end

local function setupStats()
    local GUI = DuneMUD.ui.GUI

    GUI.statsBox = GUI.statsBox or Geyser.VBox:new({
      name = "statsBox",
      width = "99%",
      height = "99%",
    }, GUI.topRight.Statscenter)

    GUI.statsConsole = GUI.statsConsole or Geyser.MiniConsole:new({
      name = "statsConsole",
      color = "black",
      scrollBar = false,
      fontSize = 12,
    }, GUI.statsBox)

    GUI.statsConsole:echo("Hello from statsBox!")
end

function DuneMUD.ui.setup()
  DuneMUD.ui.GUI = DuneMUD.ui.GUI or {}

  setupBaseLayout()
  setupChannels()
  setupVitals()
  setupTopRight()
  setupStats()
  setupMap()

  DuneMUD.ui.show()
end

function DuneMUD.ui.tearDown()
  DuneMUD.ui.hide()

  DuneMUD.ui.GUI = nil
  DuneMUD.ui = nil
end

function DuneMUD.ui.show()
  local GUI = DuneMUD.ui.GUI

  GUI.top:show()
  GUI.bottom:show()
  GUI.right:show()

  GUI.top:attachToBorder("top")
  GUI.bottom:attachToBorder("bottom")
  GUI.right:attachToBorder("right")

  GUI.top:connectToBorder("right")
  GUI.bottom:connectToBorder("right")
end

function DuneMUD.ui.hide()
  local GUI = DuneMUD.ui.GUI

  GUI.right:hide()
  GUI.bottom:hide()
  GUI.top:hide()
end

function DuneMUD.ui.onChannelList(_, channelList)
  local channelEMCO = DuneMUD.ui.GUI.channelEMCO

  for _, chan_info in ipairs(channelList) do
    local chan_name = chan_info.name
    local chan_enabled = chan_info.enabled
    local tabbed = (tabbedChans[chan_name] or DuneMUD.config.extraTabbedChans[chan_name])
    local tab_exists = table.contains(channelEMCO.consoles, chan_name)

    if chan_enabled == 1 and tabbed and not tab_exists then
      channelEMCO:addTab(chan_name)
    end
  end

  channelEMCO:switchTab("all")
end

function DuneMUD.ui.onChannelText(_, channelText)
  local channelEMCO = DuneMUD.ui.GUI.channelEMCO

  local chan_name = channelText.channel
  local text = channelText.channel_ansi .. " " .. channelText.text
  local tabbed = (tabbedChans[chan_name] or DuneMUD.config.extraTabbedChans[chan_name])
  local tab_exists = table.contains(channelEMCO.consoles, chan_name)

  if tabbed and not tab_exists then
    channelEMCO:addTab(chan_name)
  end

  if tabbed then
    channelEMCO:decho(chan_name, ansi2decho(text))
  else
    channelEMCO:decho("other", ansi2decho(text))
  end
end


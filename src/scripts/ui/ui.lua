dunemud = dunemud or {}
dunemud.config = dunemud.config or {}
dunemud.ui = dunemud.ui or {}

local function showChannelEMCO()
  local default_constraints = {
    name = "TopWindow", 
    x = "0",
    y = "0", 
    width = "100%",
    height = "200px",
  }
  local stylesheet = [[background-color: rgb(0,180,0,255); border-width: 1px; border-style: solid; border-color: gold; border-radius: 10px;]]
  local istylesheet = [[background-color: rgb(60,60,60,255); border-width: 1px; border-style: solid; border-color: gold; border-radius: 10px;]]

  -- TODO(@paradox): Adjustable container errs from nil locale?
  --dunemud.ui.container = dunemud.ui.container or Adjustable.Container:new(default_constraints)
  dunemud.ui.container = dunemud.ui.container or Geyser.Container:new(default_constraints)
  dunemud.ui.container:show()

  local EMCO = require("@PKGNAME@.mdk.emco")
  dunemud.ui.channelEMCO = dunemud.ui.channelEMCO or EMCO:new({
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
  }, dunemud.ui.container)
end

local function hideChannelEMCO()
  dunemud.ui.container:hide()
end

local function showUI()
  debugc("Setting up DuneMUD UI")
  cecho("<green>Loaded DuneMUD Mudlet<reset>\n")
  showChannelEMCO()
end

local function hideUI()
  debugc("Removing DuneMUD UI")
  hideChannelEMCO()
end

-- TODO(@paradox): Move event handlers?

local function onProfileLoad()
  showUI()
end

local function onInstall(_, package)
  if package ~= "@PKGNAME@" then return end
  showUI()
end

local function onTearDown(_, package)
  if package ~= "@PKGNAME@" then return end
  hideUI()
end

local function onChannelList()
  local channelEMCO = dunemud.ui.channelEMCO
  for _, chan_info in ipairs(gmcp.Comm.Channel.List) do
    local chan_name = chan_info.name
    local chan_enabled = chan_info.enabled
    if chan_enabled == 1 and not table.contains(channelEMCO.consoles, chan_name) then
      channelEMCO:addTab(chan_name)
    end
  end
end

function onChannelText()
  local channelEMCO = dunemud.ui.channelEMCO
  local chan_name = gmcp.Comm.Channel.Text.channel
  local text = gmcp.Comm.Channel.Text.channel_ansi .. " " .. gmcp.Comm.Channel.Text.text
  if not table.contains(channelEMCO.consoles, chan_name) then
    channelEMCO:addTab(chan_name)
  end
  channelEMCO:decho(chan_name, ansi2decho(text))
end

local user = dunemud.config.user
registerNamedEventHandler(user, "uiLoad", "sysLoadEvent", onProfileLoad)
registerNamedEventHandler(user, "uiInit", "sysInstall", onInstall)
registerNamedEventHandler(user, "uiTeardown", "sysUninstall", onTearDown)
registerNamedEventHandler(user, "onChannelList", "gmcp.Comm.Channel.List", onChannelList)
registerNamedEventHandler(user, "onChannelText", "gmcp.Comm.Channel.Text", onChannelText)

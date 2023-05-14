-- Official DuneMUD Mudlet Plugin
--
-- Changelog:
--   - 2023-05-11 - Paradox@DUNE - Initial version
--
-- Plugin initialization and dispatch code.

local defaultConfig = {
  -- Used for registering event handlers, etc. Does not need to match in-game
  -- username.
  user = 'DuneMUD',
}

DuneMUD = DuneMUD or {}
DuneMUD.config = DuneMUD.config or defaultConfig

-- Event handler registration/unregistration approach inspired by
-- Geslar@Threshold. Thanks!
DuneMUD.eventHandlers = {
  -- GMCP handlers. These are defined in gmcp.lua and should mostly
  -- translate between GMCP events and our own DuneMUDXXX events.
  { "DuneMUDGMCPEnabled", "DuneMUD.gmcp.setup", nil },
  { "gmcp.Comm.Channel.List", "DuneMUD.gmcp.channelList", nil },
  { "gmcp.Comm.Channel.Text", "DuneMUD.gmcp.channelText", nil },
  { "gmcp.Room.Info", "DuneMUD.gmcp.roomInfo", nil },

  -- UI handlers. These are defined in ui.lua and should only
  -- be reacting to DuneMUDXXX events.
  { "DuneMUDLoaded", "DuneMUD.ui.setup", nil },
  { "DuneMUDInstalled", "DuneMUD.ui.setup", nil },
  { "DuneMUDUninstalled", "DuneMUD.ui.tearDown", nil },
  { "DuneMUDChannelList", "DuneMUD.ui.onChannelList", nil },
  { "DuneMUDChannelText", "DuneMUD.ui.onChannelText", nil },

  -- Mapper handlers. These are defined in mapper.lua and should
  -- only be reacting to DuneMUDXXX events.
  { "DuneMUDInstalled", "DuneMUD.map.setup", nil },
  { "DuneMUDUninstalled", "DuneMUD.map.tearDown", nil },
  { "DuneMUDRoomInfo", "DuneMUD.map.onRoomInfo", nil },
}

function DuneMUD.registerEventHandlers()
  for i, v in ipairs(DuneMUD.eventHandlers) do
    if v[3] == nil then
      DuneMUD.eventHandlers[i][3] = registerAnonymousEventHandler(v[1], v[2])
    end
  end
end

function DuneMUD.deregisterEventHandlers()
  for i, v in ipairs(DuneMUD.eventHandlers) do
    if v[3] ~= nil then killAnonymousEventHandler(v[3]) end
  end
end

local function onInstall(_, package)
  if package ~= "@PKGNAME@" then return end

  DuneMUD.registerEventHandlers()
  raiseEvent("DuneMUDInstalled")
  cecho("<green>Installed DuneMUD.<reset>\n")
end

local function onProfileLoad()
  DuneMUD.registerEventHandlers()
  raiseEvent("DuneMUDLoaded")
  cecho("<green>Loaded DuneMUD.<reset>\n")
end

local function onUninstall(_, package)
  if package ~= "@PKGNAME@" then return end

  raiseEvent("DuneMUDUninstalled")

  DuneMUD.deregisterEventHandlers()
  cecho("<red>Uninstalled DuneMUD.<reset>\n")
end

local function onProtocolEnabled(_, protocol)
  if protocol == "GMCP" then
    cecho("<green>GMCP Enabled.<reset>\n")
    raiseEvent("DuneMUDGMCPEnabled")
  end
end

-- Core event handlers. These are system events that drive the
-- registration/deregistration of the plugin event handlers. You should not be
-- adding new event handlers here.
registerNamedEventHandler(DuneMUD.config.user, "DuneMUDInstall", "sysInstall", onInstall)
registerNamedEventHandler(DuneMUD.config.user, "DuneMUDLoad", "sysLoadEvent", onProfileLoad)
registerNamedEventHandler(DuneMUD.config.user, "DuneMUDUninstall", "sysUninstall", onUninstall)
registerNamedEventHandler(DuneMUD.config.user, "DuneMUDProtocolEnabled", "sysProtocolEnabled", onProtocolEnabled)

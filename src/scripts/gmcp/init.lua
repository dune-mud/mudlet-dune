dunemud = dunemud or {}
dunemud.config = dunemud.config or {}

local function onProtocolEnabled(_, protocol)
  if protocol == "GMCP" then
    -- TODO(@paradox: Iterate list of modules to enable.
    -- Register for Channel events.
    gmod.enableModule("", "Comm.Channel")

    raiseEvent("duneMudGmcpInit")
  end
end

-- Set up the sysProtocolEnabled event handler.
local user = dunemud.config.user
registerNamedEventHandler(user, "gmcpInit", "sysProtocolEnabled", onProtocolEnabled)

--
-- GMCP specific code.
--
-- Translates game GMCP events into DuneMUD plugin specific events.
--

DuneMUD = DuneMUD or {}
DuneMUD.config = DuneMUD.config or {}
DuneMUD.gmcp = DuneMUD.gmcp or {}

-- GMCP modules we support above/beyond defaults sent by Mudlet.
DuneMUD.gmcp.supportedModules = DuneMUD.gmcp.supportedModules or {
  "Comm.Channel",
  "Char.Guild",
}

function DuneMUD.gmcp.setup()
  for _, module in ipairs(DuneMUD.gmcp.supportedModules) do
    gmod.enableModule(DuneMUD.config.user, module)
  end
end

function DuneMUD.gmcp.channelList()
  raiseEvent("DuneMUDChannelList", gmcp.Comm.Channel.List)
end

function DuneMUD.gmcp.channelText()
  raiseEvent("DuneMUDChannelText", gmcp.Comm.Channel.Text)
end

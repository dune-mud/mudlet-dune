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

DuneMUD.gmcp.mergeTables = DuneMUD.gmcp.mergeTables or {
  "Char.Guild",
  "Char.Skills",
  "Char.Status",
  "Char.Stats",
  "Char.MaxStats",
  "Char.Vitals",
}

function DuneMUD.gmcp.setup()
  for _, module in ipairs(DuneMUD.gmcp.supportedModules) do
    gmod.enableModule(DuneMUD.config.user, module)
  end
  for _, mergeTable in ipairs(DuneMUD.gmcp.mergeTables) do
    setMergeTables(mergeTable)
  end
end

function DuneMUD.gmcp.charName()
  raiseEvent("DuneMUDLogin", gmcp.Char.Name)
end

function DuneMUD.gmcp.charVitals()
  raiseEvent("DuneMUDVitals", gmcp.Char.Vitals)
end

function DuneMUD.gmcp.char()
  raiseEvent("DuneMUDCharSkills", gmcp.Char.Skills)
  raiseEvent("DuneMUDCharStats", gmcp.Char.Stats)
end

function DuneMUD.gmcp.charStatus()
  raiseEvent("DuneMUDCharStatus", gmcp.Char)
end

function DuneMUD.gmcp.charGuild()
  raiseEvent("DuneMUDCharGuild", gmcp.Char.Guild)
end

function DuneMUD.gmcp.channelList()
  raiseEvent("DuneMUDChannelList", gmcp.Comm.Channel.List)
end

function DuneMUD.gmcp.channelText()
  raiseEvent("DuneMUDChannelText", gmcp.Comm.Channel.Text)
end

function DuneMUD.gmcp.roomInfo()
  raiseEvent("DuneMUDRoomInfo", gmcp.Room.Info)
end

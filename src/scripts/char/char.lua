--
-- Character data.
--
DuneMUD = DuneMUD or {}
DuneMUD.character = DuneMUD.character or {
  Vitals = {},
  Guild = {},
  Skills = {},
  Status = {},
  Stats = {}
}

function DuneMUD.character.login(_, charData)
  -- Update character name/guild and raise an event to load the right 
  -- per-guild scripts.
  DuneMUD.character.name = charData.name
  DuneMUD.character.guild = charData.guild

  raiseEvent("DuneMUDLoadGuild", charData.guild)
end

function DuneMUD.character.vitalsUpdate(_, charVitals)
  if charVitals == nil then
    return
  end
  DuneMUD.character.Vitals = charVitals
  raiseEvent("DuneMUD.character.vitalsUpdated")
end

function DuneMUD.character.statusUpdate(_, charData)
  if charData.Status == nil then
    return
  end
  DuneMUD.character.Status = charData.Status
  raiseEvent("DuneMUD.character.statusUpdated", DuneMUD.character.Status)
end

function DuneMUD.character.statsUpdate(_, charStats)
  if charStats == nil then
    return
  end
  DuneMUD.character.Stats = charStats
  raiseEvent("DuneMUD.character.statsUpdated", DuneMUD.character.Stats)
end

function DuneMUD.character.guildUpdate(_, charGuild)
  if charGuild == nil then
    return
  end
  DuneMUD.character.Guild = charGuild
  -- raiseEvent("DuneMUD.character.guildUpdated", DuneMUD.character.Guild)
end
function DuneMUD.character.skillsUpdate(_, charSkills)
  if charSkills == nil then
    return
  end
  DuneMUD.character.Skills = charSkills
  -- raiseEvent("DuneMud.character.skillsUpdated", DuneMUD.character.Skills)
end

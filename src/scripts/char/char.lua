--
-- Character data.
--
DuneMUD = DuneMUD or {}
DuneMUD.character = DuneMUD.character or {
  hp = 100,
  maxhp = 100,
  cp = 100,
  maxcp = 100,
  Guild = {},
  Skills = {},
  Status = {},
  Stats = {
    Strength = 0,
    Constitution = 0,
    Intelligence = 0,
    Wisdom = 0,
    Dexterity = 0,
    Quickness = 0
  },
}

function DuneMUD.character.login(_, charData)
  -- Update character name/guild and raise an event to load the right 
  -- per-guild scripts.
  DuneMUD.character.name = charData.name
  DuneMUD.character.guild = charData.guild

  raiseEvent("DuneMUDLoadGuild", charData.guild)
end

function DuneMUD.character.vitalsUpdate(_, charVitals)
  if charVitals.hp then
    DuneMUD.character.hp = charVitals.hp
  end
  if charVitals.maxhp then
    DuneMUD.character.maxhp = charVitals.maxhp
  end
  if charVitals.sp then
    DuneMUD.character.cp = charVitals.sp
  end
  if charVitals.maxsp then
    DuneMUD.character.maxcp = charVitals.maxsp
  end
  
  raiseEvent("DuneMUD.character.vitalsUpdated")
end

function DuneMUD.character.statusUpdate(_, charData)
  
  if charData.Status then
    DuneMUD.character.Status = charData.Status
    raiseEvent("DuneMUD.character.statusUpdated", DuneMUD.character.Status)
  end

  if charData.Stats == nil then
    return
  end

  local stats = charData.Stats

  if stats.str then
    DuneMUD.character.Stats.Strength = charData.Stats.str
  end

  if stats.con then
    DuneMUD.character.Stats.Constitution = stats.con
  end

  if stats.int then
    DuneMUD.character.Stats.Intelligence = charData.Stats.int
  end

  if stats.wis then
    DuneMUD.character.Stats.Wisdom = charData.Stats.wis
  end

  if stats.dex then
    DuneMUD.character.Stats.Dexterity = charData.Stats.dex
  end

  if stats.qui then
    DuneMUD.character.Stats.Quickness = charData.Stats.qui
  end

  raiseEvent("DuneMUD.character.statsUpdated", DuneMUD.character.Stats)
end

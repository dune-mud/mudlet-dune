--
-- Character data.
--
DuneMUD = DuneMUD or {}
DuneMUD.character = DuneMUD.character or {
  hp = 100,
  maxhp = 100,
  cp = 100,
  maxcp = 100,
  Status = {},
  Stats = {},
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
  DuneMUD.character.Status = charData.Status
  DuneMUD.character.Stats.Strength = charData.Stats.str
  DuneMUD.character.Stats.Constitution = charData.Stats.con
  DuneMUD.character.Stats.Intelligence = charData.Stats.int
  DuneMUD.character.Stats.Wisdom = charData.Stats.wis
  DuneMUD.character.Stats.Dexterity = charData.Stats.dex
  DuneMUD.character.Stats.Quickness = charData.Stats.qui

  raiseEvent("DuneMUD.character.statusUpdated", DuneMUD.character.Status)
  raiseEvent("DuneMUD.character.statsUpdated", DuneMUD.character.Stats)
end

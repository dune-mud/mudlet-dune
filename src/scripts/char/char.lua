--
-- Character data.
--
DuneMUD = DuneMUD or {}
DuneMUD.character = DuneMUD.character or {
  hp = 100,
  maxhp = 100,
  cp = 100,
  maxcp = 100,
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
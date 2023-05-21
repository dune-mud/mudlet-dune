--
-- Character data.
--
DuneMUD = DuneMUD or {}
DuneMUD.character = DuneMUD.character or {
  hp = 100,
  maxhp = 100,
  sp = 100,
  maxsp = 100,
}

function DuneMUD.character.login(_, charData)
  -- Update character name/guild and raise an event to load the right 
  -- per-guild scripts.
  DuneMUD.character.name = charData.name
  DuneMUD.character.guild = charData.guild

  raiseEvent("DuneMUDLoadGuild", charData.guild)
end

function DuneMUD.character.vitalsUpdate(_, charVitals)
  -- an initial update with just a character name was received.
  if charVitals.maxhp == 0 and charVitals.maxcp == 0 then
    return
  end

  -- Update character vitals
  DuneMUD.character.hp = charVitals.hp
  DuneMUD.character.maxhp = charVitals.maxhp
  -- NB: We translate from SP -> CP here.
  DuneMUD.character.cp = charVitals.sp
  DuneMUD.character.maxcp = charVitals.maxsp

  raiseEvent("DuneMUDVitalsUpdated", DuneMUD.character)
end

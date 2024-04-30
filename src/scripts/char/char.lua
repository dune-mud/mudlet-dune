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

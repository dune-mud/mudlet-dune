--
-- Character data.
--
DuneMUD = DuneMUD or {}
DuneMUD.character = DuneMUD.character or {}

function DuneMUD.character.login(_, charData)
  DuneMUD.character.name = charData.name
  DuneMUD.character.guild = charData.guild

  raiseEvent("DuneMUDLoadGuild", charData.guild)
end

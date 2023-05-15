--
-- Guildless code.
--

DuneMUD = DuneMUD or {}
DuneMUD.guild = DuneMUD.guild or {}
DuneMUD.guild.none = DuneMUD.guild.none or {}
local guild = DuneMUD.guild.none

function guild.setup(_, guild)
  if guild ~= "None" and guild ~= "none" then return end

  --cecho("Setting up none guild\n")
end

function guild.tearDown()
  --cecho("Tearing down none guild\n")
end

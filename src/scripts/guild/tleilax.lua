--
-- Tlx code.
--

DuneMUD = DuneMUD or {}
DuneMUD.guild = DuneMUD.guild or {}
DuneMUD.guild.Tleilax = DuneMUD.guild.Tleilax or {}
local guild = DuneMUD.guild.Tleilax

function guild.setup(_, guild)
  if guild ~= "Tleilax" then return end

  --cecho("Setting up Tlx guild\n")
end

function guild.tearDown()
  --cecho("Tearing down Tlx guild\n")
end

-- Official DuneMUD Mudlet Plugin
--
-- Changelog:
--   - 2023-05-11 - Paradox@DUNE - Initial version
--

local defaultConfig = { 
  -- Used for registering event handlers, etc. Does not need to match in-game
  -- username.
  user = 'DuneMUD',
}

dunemud = dunemud or {}
dunemud.config = dunemud.config or defaultConfig

-- By Paradox@DUNE
--
-- Heavily based on the generic GMCP mapping script for Mudlet
-- by Blizzard. https://worldofpa.in

DuneMUD = DuneMUD or {}
DuneMUD.map = DuneMUD.map or {}

map = DuneMUD.map
map.room_info = map.room_info or {}
map.prev_info = map.prev_info or {}

-- list of possible movement directions and appropriate coordinate changes
local move_vectors = {
  north = {0,1,0}, south = {0,-1,0}, east = {1,0,0}, west = {-1,0,0},
  northwest = {-1,1,0}, northeast = {1,1,0}, southwest = {-1,-1,0}, southeast = {1,-1,0},
  up = {0,0,1}, down = {0,0,-1}
}

local stubmap = {
  north = 1,      northeast = 2,      northwest = 3,      east = 4,
  west = 5,       south = 6,          southeast = 7,      southwest = 8,
  up = 9,         down = 10,          ["in"] = 11,        out = 12,
  [1] = "north",  [2] = "northeast",  [3] = "northwest",  [4] = "east",
  [5] = "west",   [6] = "south",      [7] = "southeast",  [8] = "southwest",
  [9] = "up",     [10] = "down",      [11] = "in",        [12] = "out",
}

local function make_stub_room(hash)
  local roomID = createRoomID()
  setRoomIDbyHash(roomID, hash)
  addRoom(roomID)
  --echo("Associated hash ".. hash .." with room ID ".. roomID .. "\n")
  return roomID
end

local function configure_room()
  --echo("handling configure_room()\n")
  local info = map.room_info
  local coords = {0,0,0}

  --echo("Setting room ".. info.vnum .." to name ".. info.name .."\n")
  setRoomName(info.vnum, info.name)

  local areas = getAreaTable()
  local areaID = areas[info.area]
  if not areaID then
    --echo("adding new area ID for ".. info.area .."\n")
    areaID = addAreaName(info.area)
  else
    --echo("using existing area ID ".. areaID .." for area ".. info.area .."\n")
  end
  setRoomArea(info.vnum, areaID)

  --echo("Setting initial coords\n")

  local coords = {0,0,0}
  if map.prev_info.vnum and getRoomCoordinates(map.prev_info.vnum) then
    --echo("Setting initial coords to previous room's coords\n")
    coords = {getRoomCoordinates(map.prev_info.vnum)}
    --echo("Coords: ".. coords[1] ..", ".. coords[2] ..", ".. coords[3] .."\n")
  else
    --echo("Using 0,0,0 as initial coords. No prev room coords\n")
  end

  local shift = {0,0,0}
  -- Look at each of the exit to room number pairs and see if the room 
  -- number of the previous room matches one of the exits in this room.
  -- If so, and we know how to get a move_vector for the exit direction
  -- we can figure out this room's coords by shifting from the prev room.
  for dir,roomID in pairs(info.exits) do
    if roomID == map.prev_info.vnum and move_vectors[dir] then
      shift = move_vectors[dir]
      --echo("Found a shift from room ID ".. roomID .. " for dir ".. dir .. "\n")
      break
    end
  end

  for n = 1,3 do
    coords[n] = (coords[n] or 0) - (shift[n] or 0)
  end

  --echo("Considering this room (pre-shift) at ".. coords[1] ..", ".. coords[2] ..", ".. coords[3] .."\n")
  -- map stretching
  local overlap = getRoomsByPosition(areaID, coords[1],coords[2],coords[3])
  if not table.is_empty(overlap) then
    --echo("Need to stretch - found rooms at the pre-shift position.\n")
    local rooms = getAreaRooms(areaID)
    local rcoords
    --echo("Shift:")
    display(shift)
    for _,id in ipairs(rooms) do
      --echo("Considering room id ".. id .." at ")
      rcoords = {getRoomCoordinates(id)}
      display(rcoords)
      for n = 1,3 do
        if shift[n] ~= 0 and (rcoords[n] - coords[n]) * shift[n] <= 0 then
          rcoords[n] = rcoords[n] - shift[n]
        end
      end
      --echo("Moving to ")
      display(rcoords)
      setRoomCoordinates(id,rcoords[1],rcoords[2],rcoords[3])
    end
  end
  --echo("Setting post-shift coords: (".. coords[1] .. ", ".. coords[2] .. ", ".. coords[3] ..")\n")
  setRoomCoordinates(info.vnum, coords[1], coords[2], coords[3])

  --if info.exits then
  --  display(info.exits)
  --end

  for dir, id in pairs(info.exits) do
    if id and getRoomName(id) ~= "" then
      --echo("Setting exit "..dir.." to room ID ".. id .. "\n")
      setExit(info.vnum, id, dir)
    elseif stubmap[dir] then
      --echo("Creating stub exit for normal dir ".. dir .." to stub room ID ".. id .."\n")
      setExitStub(info.vnum, dir, true)
    else
      --echo("(TBD) Creating special exit for dir ".. dir .." to stub room ID ".. id .."\n")
    end
  end

  --echo("Done configuring room\n")
end

local function handle_move()
  --echo("Running handle_move()\n")
  local info = map.room_info
  --echo("Current hash ".. info.hash .. "\n")
  local id = getRoomIDbyHash(info.hash)
  --echo("Current ID ".. id .. "\n")

  -- If we haven't created a stub room yet, do that now.
  if id == -1 then
    info.vnum = make_stub_room(info.hash)
    --echo("Created stub room with ID ".. info.vnum .. " for this room\n")
  else
    info.vnum = id
    --echo("Found existing room with ID ".. info.vnum .. " for this room\n")
  end

  if not getRoomName(id) or getRoomName(id) == "" then
    --echo("Configuring room\n")
    configure_room()
  else
    --echo("Room was already configured\n")
  end

  local stubs = getExitStubs1(info.vnum)
  if stubs then
    --echo("Processing stubs.\n")
    for _, n in ipairs(stubs) do
      dir = stubmap[n]
      local id = info.exits[dir]
      if getRoomName(id) ~= "" then
        setExit(info.vnum, id, dir)
        --echo("setting exit ".. dir .. " to ".. id .. "\n")
      else
        --echo("not setting exit for ".. dir .. "\n")
      end
    end
  else
    --echo("No stubs to process\n")
  end
  --echo("Centering on ".. info.vnum .."\n")
  centerview(info.vnum)
end

function DuneMUD.map.setup()
  -- Check if the generic_mapper package is installed and if so uninstall it
  -- DuneMUD is not compatible with this.
  if table.contains(getPackages(), "generic_mapper") then
    uninstallPackage("generic_mapper")
  end
end

function DuneMUD.map.tearDown()
  -- TODO(@Paradox): Revisit.
  --if not table.contains(getPackages(), "generic_mapper") then
  --  local generic_mapper_url = "https://raw.githubusercontent.com/Mudlet/Mudlet/development/src/mudlet-lua/lua/generic-mapper/generic_mapper.xml"
  --  installPackage(generic_mapper_url)
  --end
end

function doSpeedWalk(...)
  cecho("Speed walking not implemented yet...\n")
end

function DuneMUD.map.onRoomInfo(_, ...)
  -- Handle a room info event. Typically this happens when
  -- the player has moved and we need to process a new environment.

  -- Stash the previous room info before 
  map.prev_info = map.room_info

  -- Grab the room's hash from the "num" field. Dune does
  -- not have room numbers and we need to do a mapping 
  -- to IDs that Mudlet manages by a hash the game sends.
  local hash = gmcp.Room.Info.num
  -- NB: id will be nil for rooms not yet visited.
  local id = getRoomIDbyHash(hash)

  -- Populate some local data about the room.
  map.room_info = {
    hash = hash,
    vnum = id,
    area = gmcp.Room.Info.area,
    name = gmcp.Room.Info.name,
    terrain = gmcp.Room.Info.environment,
    -- at this point we have exits that point to hashes.
    exit_hashes = gmcp.Room.Info.exits,
    -- we will want exits that point to room IDs. This
    -- table will hold those.
    exits = {},
  }

  -- opportunistically create room IDs for the hashes that make our exits.
  -- for the stub rooms we will create them without information and fill
  -- it in later.
  for dir, h in pairs(map.room_info.exit_hashes) do
    id = getRoomIDbyHash(h)
    if id == -1 then
      id = make_stub_room(h)
      --echo("exit ".. dir .." pointing to stub room id ".. id .. "\n")
    else
      --echo("exit ".. dir .." pointing to configured room id ".. id .. "\n")
    end
    map.room_info.exits[dir] = id
  end
  -- Handle the movement now that map.room_info is set up.
  handle_move()
end

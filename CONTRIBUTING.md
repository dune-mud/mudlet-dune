# Contributing

## One-time Local Setup

To be able to hot-reload the plugin from your local files you need to do some
one-time setup in a Mudlet profile you'll use for development.

* Clone this repo somewhere.
* Install and run [Mudlet] - currently we're developing on 4.17.x.
* Download [Muddler] - you'll need a Java JVM setup to run it.
* In Mudlet, install [the Muddler mpackage][Muddler.mpackage]
* Next, create a helper script with the following content:

```lua
-- IMPORTANT: CHANGE THIS TO WHERE YOU CLONED THE MUDLET-DUNE REPO!!
local pluginPath = "/home/YOUR_NAME/mudlet-dune"

local function killDuneMUD()
  for pkgName, _ in pairs(package.loaded) do
    if pkgName:find("DuneMUD") then
      debugc("Uncaching lua package " .. pkgName)
      package.loaded[pkgName] = nil
    end
  end
end
local function create_helper()
  if DuneMUDHelper then MDKhelper:stop() end
  DuneMUDHelper = Muddler:new({
    path = pluginPath,
    postremove = killDuneMUD,
  })
end
if not DuneMUDHelper then
  registerAnonymousEventHandler("sysLoadEvent", create_helper)
end
```
* Remember to change `pluginPath` to where you keep the `mudlet-dune` git repo.
* That's it for one-time setup!

[Mudlet]: https://www.mudlet.org/
[Muddler]: https://github.com/demonnic/muddler/releases/tag/1.0.1
[Muddler.mpackage]: https://github.com/demonnic/muddler/releases/download/1.0.1/Muddler.mpackage

## Developing 

* Edit the plugin code in your IDE of choice.
* Build your changes by running `muddler`.
* That's it - they'll be reloaded in your Mudlet profile thanks to the one-time
  setup.

## Publishing

* Open a PR.
* Wait for CI to pass.
* Look for the published artifact.
* Convince the MUD admins to update the GMCP package to use the new artifact.

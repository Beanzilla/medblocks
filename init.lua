
medblocks = {}

medblocks.MODPATH = minetest.get_modpath("medblocks")
medblocks.VERSION = "1.1.0"
medblocks.settings = {
    mednode = {
        allow_crafting = false,
        range = 1.0,
        healing = 1
    },
    medpack = {
        allow_crafting = false,
        healing = 1
    },
    feednode = {
        allow_crafting = false,
        range = 1.0,
        feeding = 1
    },
    feedpack = {
        allow_crafting = false,
        feeding = 1
    }
}
medblocks.hunger_installed = false

medblocks.gamemode = "???"
if minetest.get_modpath("default") ~= nil then
    medblocks.gamemode = "MTG"
elseif minetest.get_modpath("mcl_core") ~= nil then
    medblocks.gamemode = "MCL"
end

-- Get mod settings (defined in `minetest.conf`)
dofile(medblocks.MODPATH .. DIR_DELIM .. "settings.lua")
dofile(medblocks.MODPATH .. DIR_DELIM .. "food_check.lua")

-- Register the mednode a node which heals players
dofile(medblocks.MODPATH .. DIR_DELIM .. "mednode.lua")

-- Register the medpack a item which heals the player (so long as it's in their inventory)
-- Also counts recursive packs (more packs, more health per 3 seconds)
dofile(medblocks.MODPATH .. DIR_DELIM .. "medpack.lua")

if medblocks.hunger_installed == true then
    -- Register the feednode a node which feeds players (should be disabled if no hunger mod is detected)
    dofile(medblocks.MODPATH .. DIR_DELIM .. "feednode.lua")

    -- Register the feedpack a item which feeds the player (so long as it's in their inventory)
    -- Also counts recursive packs (more packs, more food per 3 seconds)
    dofile(medblocks.MODPATH .. DIR_DELIM .. "feedpack.lua")
end

-- Crafting recipes (optional)
dofile(medblocks.MODPATH .. DIR_DELIM .. "crafting.lua")

-- Basic notice that we are ready
minetest.log("action", "[medblocks] Version: " .. medblocks.VERSION)
minetest.log("action", "[medblocks] Gamemode: " .. medblocks.gamemode)
if medblocks.hunger_installed == true then
    minetest.log("action", "[medblocks] Hunger Mod: Found")
else
    minetest.log("action", "[medblocks] Hunger Mod: Not Found")
end

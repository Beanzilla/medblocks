
local settings = medblocks.settings

-- Mednode
settings.mednode.allow_crafting = minetest.settings:get_bool("medblocks.mednode.allow_crafting")
if settings.mednode.allow_crafting == nil then
    settings.mednode.allow_crafting = false
    minetest.settings:set_bool("medblocks.mednode.allow_crafting", settings.mednode.allow_crafting)
end

settings.mednode.range = minetest.settings:get("medblocks.mednode.range")
if settings.mednode.range == nil then
    settings.mednode.range = 1.0
    minetest.settings:set("medblocks.mednode.range", settings.mednode.range)
else
    settings.mednode.range = tonumber(settings.mednode.range)
end

settings.mednode.healing = minetest.settings:get("medblocks.mednode.healing")
if settings.mednode.healing == nil then
    settings.mednode.healing = 1
    minetest.settings:set("medblocks.mednode.healing", settings.mednode.healing)
else
    settings.mednode.healing = tonumber(settings.mednode.healing)
end

-- Medpack
settings.medpack.allow_crafting = minetest.settings:get_bool("medblocks.medpack.allow_crafting")
if settings.medpack.allow_crafting == nil then
    settings.medpack.allow_crafting = false
    minetest.settings:set_bool("medblocks.medpack.allow_crafting", settings.medpack.allow_crafting)
end

settings.medpack.healing = minetest.settings:get("medblocks.medpack.healing")
if settings.medpack.healing == nil then
    settings.medpack.healing = 1
    minetest.settings:set("medblocks.medpack.healing", settings.medpack.healing)
else
    settings.medpack.healing = tonumber(settings.medpack.healing)
end

-- Feednode
settings.feednode.allow_crafting = minetest.settings:get_bool("medblocks.feednode.allow_crafting")
if settings.feednode.allow_crafting == nil then
    settings.feednode.allow_crafting = false
    minetest.settings:set_bool("medblocks.feednode.allow_crafting", settings.feednode.allow_crafting)
end

settings.feednode.range = minetest.settings:get("medblocks.feednode.range")
if settings.feednode.range == nil then
    settings.feednode.range = 1.0
    minetest.settings:set("medblocks.feednode.range", settings.feednode.range)
else
    settings.feednode.range = tonumber(settings.feednode.range)
end

settings.feednode.feeding = minetest.settings:get("medblocks.feednode.feeding")
if settings.feednode.feeding == nil then
    settings.feednode.feeding = 1.0
    minetest.settings:set("medblocks.feednode.feeding", settings.feednode.feeding)
else
    settings.feednode.feeding = tonumber(settings.feednode.feeding)
end

-- Feedpack
settings.feedpack.allow_crafting = minetest.settings:get_bool("medblocks.feedpack.allow_crafting")
if settings.feedpack.allow_crafting == nil then
    settings.feedpack.allow_crafting = false
    minetest.settings:set_bool("medblocks.feedpack.allow_crafting", settings.feedpack.allow_crafting)
end

settings.feedpack.feeding = minetest.settings:get("medblocks.feedpack.feeding")
if settings.feedpack.feeding == nil then
    settings.feedpack.feeding = 1.0
    minetest.settings:set("medblocks.feedpack.feeding", settings.feedpack.feeding)
else
    settings.feedpack.feeding = tonumber(settings.feedpack.feeding)
end

-- Debug
settings.debug_mode = minetest.settings:get_bool("medblocks.debug_mode")
if settings.debug_mode == nil then
    settings.debug_mode = false
    minetest.settings:set_bool("medblocks.debug_mode", settings.debug_mode)
end

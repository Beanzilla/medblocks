
local gear = "basic_materials:gear_steel"
local steel = "default:iron_ingot"
local circuit = "basic_materials:ic"
local energy = "basic_materials:energy_crystal_simple"

if medblocks.gamemode == "MCL" then
    steel = "mcl_core:iron_ingot"
end
if minetest.get_modpath("basic_materials") == nil then
    gear = "default:gold_ingot"
    circuit = "default:diamond"
    energy = "default:mese_crystal"
    if medblocks.gamemode == "MCL" then
        gear = "mcl_core:gold_ingot"
        circuit = "mcl_core:diamond"
        energy = "mesecons:redstone"
    end
end

-- Mednode
if medblocks.settings.mednode.allow_crafting == true then
    minetest.register_craft({
        output = "medblocks:mednode",
        recipe = {
            {steel, gear, steel},
            {steel, circuit, steel},
            {steel, energy, steel}
        }
    })
end

-- Medpack
if medblocks.settings.medpack.allow_crafting == true then
    minetest.register_craft({
        output = "medblocks:medpack",
        recipe = {
            {steel, "", steel},
            {steel, "medblocks:medpack", steel},
            {steel, "", steel}
        }
    })
end

if medblocks.hunger_installed == true then
    -- Feednode
    if medblocks.settings.feednode.allow_crafting == true then
        minetest.register_craft({
            output = "medblocks:feednode",
            recipe = {
                {steel, "", steel},
                {steel, circuit, steel},
                {steel, energy, steel}
            }
        })
    end

    -- Feedpack
    if medblocks.settings.feedpack.allow_crafting == true then
        minetest.register_craft({
            output = "medblocks:feedpack",
            recipe = {
                {steel, "", steel},
                {steel, "medblocks:feednode", steel},
                {steel, "", steel}
            }
        })
    end
end

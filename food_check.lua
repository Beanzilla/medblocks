
-- Checks if we should allow feednode and feedpack
if medblocks.hunger_installed == false and minetest.get_modpath("stamina") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == false and minetest.get_modpath("hunger_ng") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == false and minetest.get_modpath("hudbars") then
    medblocks.hunger_installed = true
end

if medblocks.hunger_installed == false and minetest.get_modpath("hbhunger") then
    medblocks.hunger_installed = true
end
